//
//  BirthdayCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 06/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
final class BirthdayCellViewModel {
    // MARK: - Properties
    private(set) var item: RegisterCellItem?
    private(set) var type: RegisterProfileType?
    private(set) var isSelected: Bool = false

    // MARK: - Initial
    init(item: RegisterCellItem?, type: RegisterProfileType? ) {
        self.item = item
        self.type = type
    }

    func updateCellStatus(isSlelected: Bool) {
        self.isSelected = isSlelected
    }
}
