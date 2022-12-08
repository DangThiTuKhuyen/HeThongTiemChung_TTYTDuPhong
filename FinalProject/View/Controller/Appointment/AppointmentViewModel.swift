//
//  AppointmentViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
final class AppointmentViewModel {
    
    var appointments: [Registration] = []
    
    func numberOfRowInSection() -> Int {
        return appointments.count
    }
    
    func viewModelForItem(at indexPath: IndexPath) -> AppointmentCellViewModel {
        return AppointmentCellViewModel(appointment: appointments[indexPath.row])
    }
}

extension AppointmentViewModel {
    
    func getAppointment(completion: @escaping APICompletion) {
        AppointmentService.getAppointment() { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return }
            switch result {
            case .success(let appointments):
                this.appointments = appointments
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
