//
//  RegisterViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 13/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

enum RegisterProfileType: Int, CaseIterable {
    case name = 0
    case birthday
    case province
    case district
    case email
    case phoneNumber
    case gender
}

struct RegisterCellItem {
    let image: String?
    let value: String?
    let placeholder: String?
}

struct UserInfo {
    var name: String = ""
    var birthday: Date?
    var province: String = ""
    var district: String = ""
    var email: String = ""
    var phoneNumber: Int = 0
    var gender: String = ""
}

final class RegisterViewModel {

    // MARK: - Enum
    enum CellType {
        case commonCell
        case genderCell

        init(from index: Int) {
            switch index {
            case 5:
                self = .genderCell
            default:
                self = .commonCell
            }
        }
    }

    // MARK: - Properties
    var address: Address? // ==> province = address.province
    var userInfo = UserInfo()

    func getDistrict() -> [District] {
        return address?.districts ?? []
    }

    func setupCell(kindOfCell: RegisterProfileType) -> RegisterCellItem? {
        switch kindOfCell {
        case .name:
            return RegisterCellItem(image: "name", value: "", placeholder: "Name")
        case .birthday:
            return RegisterCellItem(image: "birthday", value: "", placeholder: "Birthday")
        case .province:
            return RegisterCellItem(image: "address", value: address?.province, placeholder: "Province")
        case .district:
            return RegisterCellItem(image: "", value: userInfo.district, placeholder: "District")
        case .email:
            return RegisterCellItem(image: "email", value: "", placeholder: "Email")
        case .phoneNumber:
            return RegisterCellItem(image: "phone_number", value: "", placeholder: "Phone Number")
        case .gender:
            return RegisterCellItem(image: "gender", value: "", placeholder: "Phone Number")
        }
    }

    func numberOfRowInSection() -> Int {
        return RegisterProfileType.allCases.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> Any? {
        guard let type = RegisterProfileType(rawValue: indexPath.row) else { return nil }
        switch type {
        case .name, .birthday, .province, .district, .email, .phoneNumber:
            let cell = setupCell(kindOfCell: type)
            return CommonCellViewModel(item: cell, type: type)
        case .gender:
            return nil
        }
    }

    func setName(name: String) {
        userInfo.name = name
    }

    func setBirthday(birthday: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        userInfo.birthday = formatter.date(from: birthday)
    }

    func setProvince() {
        userInfo.province = address?.province ?? ""
    }

    func setDistrict(district: String) {
        userInfo.district = district
    }

    func setEmail(email: String) {
        userInfo.email = email
    }

    func setPhoneNumber(phoneNumber: String) {
        userInfo.phoneNumber = Int(phoneNumber) ?? 0
    }

    func setGender(gender: String) {
        userInfo.gender = gender
    }
}

extension RegisterViewModel {
    
    func registerAccount(completion: @escaping CompletionAPI) {
        let params = AuthService.Account(email: userInfo.email, name: userInfo.name, identityCard: 1234, birthday: "userInfo.birthday", province: userInfo.province, district: userInfo.district, phone: userInfo.phoneNumber, gender: userInfo.gender)
        AuthService.registerAccount(params: params) { [weak self] result in
            guard self != nil else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
