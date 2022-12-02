//
//  RegisterVaccineCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class RegisterVaccineCellViewModel {

    private(set) var treatment: Treatment
    private(set) var selected: Bool

    init(treatment: Treatment, selected: Bool) {
        self.treatment = treatment
        self.selected = selected
    }
}
