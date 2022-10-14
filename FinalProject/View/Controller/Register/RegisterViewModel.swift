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
    case password
}

struct RegisterCellItem {
    let image: String?
    let value: String?
    let placeholder: String?
}

final class RegisterViewModel {
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

    func setupCell(kindOfCell: RegisterProfileType) -> RegisterCellItem? {
        switch kindOfCell {
        case .name:
            return RegisterCellItem(image: "name", value: "", placeholder: "Name")
        case .birthday:
            return RegisterCellItem(image: "birthday", value: "", placeholder: "Birthday")
        case .province:
            return RegisterCellItem(image: "address", value: "", placeholder: "Province")
        case .district:
            return RegisterCellItem(image: "", value: "", placeholder: "District")
        case .email:
            return RegisterCellItem(image: "email", value: "", placeholder: "Email")
        case .phoneNumber:
            return RegisterCellItem(image: "phone_number", value: "", placeholder: "Phone Number")
        case .gender:
            return RegisterCellItem(image: "gender", value: "", placeholder: "Phone Number")
        case .password:
            return RegisterCellItem(image: "password", value: "", placeholder: "Password")
        }
    }

    func numberOfRowInSection() -> Int {
        return RegisterProfileType.allCases.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> Any? {
        guard let type = RegisterProfileType(rawValue: indexPath.row) else { return nil }
        switch type {
        case .name, .birthday, .province, .district, .email, .phoneNumber, .password:
            let cell = setupCell(kindOfCell: type)
            return CommonCellViewModel(item: cell, type: type)
        case .gender:
            return nil
        }
    }

}
