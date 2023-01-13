//
//  RegistrationViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 22/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class RegistrationViewModel {

    var registrations: [Registration] = []

    func getRegistrationSelected(at indexPath: IndexPath) -> RegisterInfo {
        let treatment = registrations[indexPath.row].disease?.treatments?.first
        let medicalCenter = registrations[indexPath.row].medicalCenter
        let time = registrations[indexPath.row].registrationTime ?? ""
        let status = registrations[indexPath.row].status
        return RegisterInfo(treatment: treatment, medicalCenter: medicalCenter, time: time, status: status)
    }
    
    func getTime(at indexPath: IndexPath) -> String {
        return registrations[indexPath.row].registrationTime ?? ""
    }
    
    func getRegistrationId(at indexPath: IndexPath) -> Int {
        return registrations[indexPath.row].registrationId ?? 0
    }
    
    func getNameDisease(at indexPath: IndexPath) -> String {
        return registrations[indexPath.row].disease?.diseaseName ?? ""
    }

    func numberOfRowInSection() -> Int {
        return registrations.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> RegistrationCellViewModel {
        return RegistrationCellViewModel(registration: registrations[indexPath.row])
    }

    func isShowTableView() -> Bool {
        return registrations.isNotEmpty
    }
}

extension RegistrationViewModel {

    func getRegistrations(completion: @escaping APICompletion) {
        RegistrationVaccineService.getRegistration { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let registrations):
                this.registrations = registrations.reversed()
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
