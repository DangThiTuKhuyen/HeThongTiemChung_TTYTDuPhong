//
//  MedicalCenterCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 23/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class MedicalCenterCellViewModel {

    private(set) var medicalCenter: MedicalCenter
    private(set) var selected: Bool = false

    init(medicalCenter: MedicalCenter, selected: Bool) {
        self.medicalCenter = medicalCenter
        self.selected = selected
    }
}
