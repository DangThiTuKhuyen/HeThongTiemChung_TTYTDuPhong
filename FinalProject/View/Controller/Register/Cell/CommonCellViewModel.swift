//
//  CommonCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 13/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class CommonCellViewModel {

    private(set) var item: RegisterCellItem?
    private(set) var type: RegisterProfileType?
    let dummy = ["Đặng", "Thị", "Tú", "Khuyên"]

    // MARK: - Initial
    init(item: RegisterCellItem?, type: RegisterProfileType? ) {
        self.item = item
        self.type = type
    }

//    func numberOfRowInSection() -> Int {
//
//    }
}
