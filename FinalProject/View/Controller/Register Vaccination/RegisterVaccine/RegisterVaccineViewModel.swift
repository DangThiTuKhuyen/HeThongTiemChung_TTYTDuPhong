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
    
    var disease: Disease

    init(disease: Disease) {
        self.disease = disease
    }

    var selectedIndexPath: IndexPath = IndexPath(row: -1, section: 0)

    func getDisaeseVaccine() -> RegisterInfo {
        let vaccine = disease.vaccines?[selectedIndexPath.row]
        return RegisterInfo(disaese: disease.diseaseName ?? "", vaccine: vaccine)
    }

    func numberOfRowInSection() -> Int {
        return disease.vaccines?.count ?? 0
    }

    func viewModelForItem(at indexPath: IndexPath, selected: Bool = false) -> RegisterVaccineCellViewModel? {
        guard let vaccine = disease.vaccines?[indexPath.row] else { return nil }
        return RegisterVaccineCellViewModel(vaccine: vaccine, selected: selected)
    }
}
