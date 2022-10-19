//
//  AddressCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class ProvinceCellViewModel {

    private(set) var address: Address
    private(set) var selected: Bool = false

    init(address: Address, selected: Bool) {
        self.address = address
        self.selected = selected
    }
}
