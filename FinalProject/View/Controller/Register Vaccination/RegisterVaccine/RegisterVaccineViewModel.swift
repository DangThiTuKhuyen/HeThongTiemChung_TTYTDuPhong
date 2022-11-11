//
//  RegisterVaccineViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class RegisterVaccineViewModel {
    
    var selectedIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    
    func viewModelForItem(at indexPath: IndexPath, selected: Bool = false) -> RegisterVaccineCellViewModel {
        return RegisterVaccineCellViewModel(selected: selected)
    }
}
