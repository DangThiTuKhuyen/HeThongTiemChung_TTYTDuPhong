//
//  RegisterInfoViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

struct RegisterInfo {
    var disaese: String
    var vaccine: Vaccine?
}

enum RegistionType: Int, CaseIterable {
    case name = 0
    case disaese
    case vaccine
    case country
    case distanceTime
    case totalDose
    case dose
    case time
    case price
}

struct RegistionCellItem {
    let title: String
    let value: String
}
final class RegisterInfoViewModel {

    var registerInfo: RegisterInfo

    init(registerInfo: RegisterInfo) {
        self.registerInfo = registerInfo
    }

    func numberOfRowInSection() -> Int {
        return RegistionType.allCases.count
    }

    func setupCell(kindOfCell: RegistionType) -> RegistionCellItem? {
        switch kindOfCell {
        case .name:
            return RegistionCellItem(title: "Name", value: Api.Profile.name)
        case .disaese:
            return RegistionCellItem(title: "Disaese", value: registerInfo.disaese)
        case .vaccine:
            return RegistionCellItem(title: "Vaccine", value: registerInfo.vaccine?.vaccineName ?? "")
        case .dose:
            return RegistionCellItem(title: "Dose", value: "Dose 1st")
        case .time:
            return RegistionCellItem(title: "Date", value: "20/10/2022")
        case .price:
            return RegistionCellItem(title: "Price", value: registerInfo.vaccine?.price?.toString() ?? "")
        case .country:
            return RegistionCellItem(title: "Country", value: registerInfo.vaccine?.country ?? "")
        case .totalDose:
            return RegistionCellItem(title: "Total dose", value: (registerInfo.vaccine?.amount ?? 0).toString())
        case .distanceTime:
            return RegistionCellItem(title: "Distance time", value: (registerInfo.vaccine?.effect ?? 0).toString() + " days" )
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> Any? {
        guard let type = RegistionType(rawValue: indexPath.row) else { return nil }
        switch type {
        case .time:
            let cell = setupCell(kindOfCell: type)
            return DatePickerCellViewModel(item: cell, type: type)
        default:
            let cell = setupCell(kindOfCell: type)
            return RegisterInfoCellViewModel(item: cell, type: type)
        }
    }

}
