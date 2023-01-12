//
//  RegisterVaccineViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import DropDown

final class RegisterVaccineViewModel {

    private(set) var treatments: [Treatment]
    private(set) var diseaseName: String
    private(set) var diseaseDescribe: String

    init(treatments: [Treatment], diseaseName: String, diseaseDescribe: String) {
        self.treatments = treatments
        self.diseaseName = diseaseName
        self.diseaseDescribe = diseaseDescribe
    }

    var selectedIndexPath: IndexPath = IndexPath(row: -1, section: 0)

    func getTreatmentSelected() -> RegisterInfo {
        let treatment = treatments[selectedIndexPath.row]
        return RegisterInfo(treatment: treatment)
    }

    func numberOfRowInSection() -> Int {
        return treatments.count
    }

    func viewModelForItem(at indexPath: IndexPath, selected: Bool = false) -> RegisterVaccineCellViewModel? {
        return RegisterVaccineCellViewModel(treatment: treatments[indexPath.row], selected: selected)
    }
}
