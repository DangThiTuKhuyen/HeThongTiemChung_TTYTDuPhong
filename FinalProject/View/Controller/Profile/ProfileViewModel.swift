//
//  ProfileViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 02/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

enum ProfileType: Int, CaseIterable {
    case avatar = 0
    case name
    case email
    case identityCard
    case numberPhone
    case gender
    case birthday
    case province
    case district
    case changePass
    case logout
}

struct ProfileCellItem {
    let title: String?
    let value: String?
}

enum SectionType: Int, CaseIterable {
    case identity = 0
    case infomation
    case security

    var rows: [ProfileType] {
        switch self {
        case .identity:
            return [.avatar, .name, .email, .identityCard]
        case .infomation:
            return [.numberPhone, .gender, .birthday, .province, .district]
        case .security:
            return [.changePass, .logout]
        }
    }
}

final class ProfileViewModel {

    enum SectionType: Int, CaseIterable {
        case identity = 0
        case infomation
        case security

        var rows: [ProfileType] {
            switch self {
            case .identity:
                return [.avatar, .name, .email, .identityCard]
            case .infomation:
                return [.numberPhone, .gender, .birthday, .province, .district]
            case .security:
                return [.changePass, .logout]
            }
        }
    }

    private(set) var profile: Profile?
    private(set) var info: Profile?
    private(set) var address: Address?
    private(set) var index: IndexPath = IndexPath(row: 0, section: 0)

    func setupCell(kindOfCell: ProfileType) -> ProfileCellItem? {
        switch kindOfCell {
        case .avatar:
            return ProfileCellItem(title: "", value: info?.image)
        case .name:
            return ProfileCellItem(title: "Name", value: info?.name)
        case .email:
            return ProfileCellItem(title: "Email", value: info?.email)
        case .numberPhone:
            return ProfileCellItem(title: "Phone", value: info?.phone?.phoneString())
        case .gender:
            return ProfileCellItem(title: "Gender", value: info?.gender)
        case .birthday:
            return ProfileCellItem(title: "Birthday", value: info?.birthday)
        case .province:
            return ProfileCellItem(title: "Province", value: info?.province)
        case .district:
            return ProfileCellItem(title: "District", value: info?.district)
        case .changePass:
            return ProfileCellItem(title: "Change password", value: "")
        case .logout:
            return ProfileCellItem(title: "Log out", value: "")
        case .identityCard:
            return ProfileCellItem(title: "Identity card", value: profile?.identityCard?.toString())
        }
    }

    func getIndex(_ indexPath: IndexPath) {
        let sectionType = SectionType(rawValue: indexPath.section)
        guard let type = sectionType?.rows[indexPath.row] else { return }
        index = IndexPath(row: type.rawValue, section: indexPath.section)
    }

    func numberOfRowInSection(inSection section: Int) -> Int {
        let sectionType = SectionType(rawValue: section)
        guard let numberRows = sectionType?.rows.count else { return 0 }
        return numberRows
    }

    func numberOfSection() -> Int {
        return SectionType.allCases.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> Any? {
        let sectionType = SectionType(rawValue: indexPath.section)
        guard let numberRows = sectionType?.rows.count, indexPath.row < numberRows else { return nil }
        guard let type = sectionType?.rows[indexPath.row] else { return nil }
        switch type {
        case .avatar:
            let cell = setupCell(kindOfCell: type)
            return NewAvatarCellViewModel(urlString: cell?.value, type: type)
        default:
            let cell = setupCell(kindOfCell: type)
            return CommonTableCellViewModel(item: cell, type: type)
        }
    }

    // MARK: - Update profile
    func setPhone(value: String) {
        info?.phone = Int(value) ?? 0
    }

    func setGender(value: String) {
        info?.gender = value
    }

    func setBirthday(value: String) {
        info?.birthday = value
    }

//    func stringBirthday() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.date(from: "2000-11-11")
//        print(date)
//        return "\(String(describing: date))"
//    }
    func setProvince(value: Address) {
        address = value
        info?.province = value.province
    }

    func getDistrictForProvince() -> [District] {
        return address?.districts ?? []
    }

    func setDistrict(value: String) {
        info?.district = value
    }
}

// MARK: - APIs
extension ProfileViewModel {
    func getProfile(completion: @escaping APICompletion) {
        ProfileService.getProfile { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let profile):
                this.profile = profile
                this.info = profile
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateProfile(completion: @escaping CompletionAPI) {
        let params = AuthService.Account(birthday: info?.birthday, province: info?.province, district: info?.district, phone: info?.phone, gender: info?.gender)
        AuthService.updateProfile(params: params) { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            if result {
                completion(.success)
            } else {
                completion(.failure(Api.Error.json.localizedDescription))
            }
        }
    }
}

// MARK: - Extension
extension Int {
    func phoneString() -> String {
        return "0" + String(self)
    }

    func toString() -> String {
        return String(self)
    }
}

extension Float {
    func toString() -> String {
        return String(self)
    }
}
