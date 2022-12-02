//
//  DetailHistoryCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

class DetailHistoryCellViewModel {

    private(set) var history: History
    private(set) var isShow: Bool

    init(history: History, isShow: Bool) {
        self.history = history
        self.isShow = isShow
    }

//    func updateCellStatus(isShow: Bool) {
//        self.isShow = isShow
//    }
}
