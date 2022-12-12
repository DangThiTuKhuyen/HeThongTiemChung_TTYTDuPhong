//
//  RegisterInfoViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

struct RegisterInfo {
    var treatment: Treatment?
    var medicalCenter: MedicalCenter?
    var time: String = ""
    var status: Bool?
}

enum RegistrationType: Int, CaseIterable {
    case name = 0
    case disaese
    case vaccine
    case country
    case distanceTime
    case totalDose
    case dose
    case medicalCenter
    case time
    case price
}

struct RegistionCellItem {
    let title: String
    let value: String
}

enum RegisterType {
    case new
    case update
}

final class RegisterInfoViewModel {

    var registerInfo: RegisterInfo
    var diseaseName: String
    var type: RegisterType
    var registrationId: Int = 0

    init(registerInfo: RegisterInfo, diseaseName: String, type: RegisterType) {
        self.registerInfo = registerInfo
        self.diseaseName = diseaseName
        self.type = type
    }

    func numberOfRowInSection() -> Int {
        return RegistrationType.allCases.count
    }

    func setupCell(kindOfCell: RegistrationType) -> RegistionCellItem? {
        switch kindOfCell {
        case .name:
            return RegistionCellItem(title: "Name", value: UserDefaults.standard.string(forKey: "userName") ?? "")
        case .disaese:
            return RegistionCellItem(title: "Disaese", value: diseaseName)
        case .vaccine:
            return RegistionCellItem(title: "Vaccine", value: registerInfo.treatment?.vaccine?.vaccineName ?? "")
        case .dose:
            return RegistionCellItem(title: "Dose", value: "Dose 1st")
        case .time:
            return RegistionCellItem(title: "Date", value: registerInfo.time)
        case .price:
            return RegistionCellItem(title: "Price", value: registerInfo.treatment?.vaccine?.vaccinePrice?.toString() ?? "")
        case .country:
            return RegistionCellItem(title: "Country", value: registerInfo.treatment?.vaccine?.country ?? "")
        case .totalDose:
            return RegistionCellItem(title: "Total dose", value: (registerInfo.treatment?.amount?.toString() ?? ""))
        case .distanceTime:
            return RegistionCellItem(title: "Distance time", value: (registerInfo.treatment?.effect?.toString() ?? "") + " days")
        case .medicalCenter:
            return RegistionCellItem(title: "Medical Center", value: registerInfo.medicalCenter?.name ?? "")
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> Any? {
        guard let type = RegistrationType(rawValue: indexPath.row) else { return nil }
        switch type {
        case .time:
            let cell = setupCell(kindOfCell: type)
            return DatePickerCellViewModel(item: cell, type: type)
        default:
            let cell = setupCell(kindOfCell: type)
            return RegisterInfoCellViewModel(item: cell, type: type)
        }
    }

    func setDate(value: String) {
        registerInfo.time = value
    }

    func setMedicalCenter(value: MedicalCenter) {
        registerInfo.medicalCenter = value
    }

    func checkEmpty() -> Bool {
        return registerInfo.time.isEmpty || registerInfo.medicalCenter?.medicalCenterId == 0
    }
}

extension RegisterInfoViewModel {

    // push
    func registerVaccine(completion: @escaping APICompletion) {
        let params = RegistrationVaccineService.Params(diseaseId: registerInfo.treatment?.diseaseId ?? 0, vaccineId: registerInfo.treatment?.vaccineId ?? 0, medicalCenterId: registerInfo.medicalCenter?.medicalCenterId ?? 0, dose: 1, time: registerInfo.time)

        switch type {
        case .new:
            RegistrationVaccineService.registerVaccine(params: params) { [weak self] result in
                guard let this = self else {
                    completion(.failure(Api.Error.json))
                    return
                }
                switch result {
                case .success:
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .update:
            RegistrationVaccineService.updateRegistration(id: registrationId, params: params) { [weak self] result in
                guard self != nil else {
                    completion(.failure(Api.Error.json))
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

    // delete
    func deleteRegistration(completion: @escaping APICompletion) {
        RegistrationVaccineService.deleteRegistration(id: registrationId) { [weak self] result in
            guard self != nil else {
                completion(.failure(Api.Error.json))
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
