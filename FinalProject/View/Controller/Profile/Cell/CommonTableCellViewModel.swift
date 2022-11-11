//
//  CommonTableCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class CommonTableCellViewModel {
    
    // MARK: - Properties
    private(set) var item: ProfileCellItem?
    private(set) var type: ProfileType?
    private(set) var isSlelected: Bool = false

    // MARK: - Initial
    init(item: ProfileCellItem?, type: ProfileType?, isSlelected: Bool = false) {
        self.item = item
        self.type = type
        self.isSlelected = isSlelected
    }

    func updateCellStatus(isSlelected: Bool) {
        self.isSlelected = isSlelected
    }
}
