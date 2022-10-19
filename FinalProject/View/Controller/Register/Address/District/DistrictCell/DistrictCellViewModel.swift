//
//  DistrictCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class DistrictCellViewModel {

    private(set) var district: District
    private(set) var selected: Bool = false

    init(district: District, selected: Bool) {
        self.district = district
        self.selected = selected
    }
}
