//
//  MedicalCenterViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 23/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class MedicalCenterViewModel {

    private var medicalCenters: [MedicalCenter] = []
    var selectedIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    var medicalCenterName: String

    init(medicalCenterName: String) {
        self.medicalCenterName = medicalCenterName
    }

    func setIndexPathSelected() {
        var i: Int = -1
        for medicalCenter in medicalCenters {
            i += 1
            if medicalCenter.name == medicalCenterName {
                selectedIndexPath.row = i
                break
            }
        }
    }
    
    func getMedicalSelected() -> MedicalCenter {
        return medicalCenters[selectedIndexPath.row]
    }

    func numberOfRowInsection() -> Int {
        return medicalCenters.count
    }

    func viewModelForItem(at indexPath: IndexPath, selected: Bool = false) -> MedicalCenterCellViewModel {
        return MedicalCenterCellViewModel(medicalCenter: medicalCenters[indexPath.row], selected: selected)
    }
}

extension MedicalCenterViewModel {

    func getMedica(completion: @escaping APICompletion) {
        RegistrationVaccineService.getMedicalCenter { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let medicalCenters):
                this.medicalCenters = medicalCenters
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
