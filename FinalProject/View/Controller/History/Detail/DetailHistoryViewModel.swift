//
//  DetailHistoryViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class DetailHistoryViewModel {
    
    var history: [History]

    init(history: [History]) {
        self.history = history
    }

    var isShows = [Bool](repeating: false, count: 10)
    
    func updateStatus(at indexPath: IndexPath) {
        isShows[indexPath.row] = !isShows[indexPath.row]
    }
    
    func numberOfRowInSection() -> Int {
        return history.count
    }
    
    func viewModelForItem(at indexPath: IndexPath) -> DetailHistoryCellViewModel {
        return DetailHistoryCellViewModel(history: history[indexPath.row], isShow: isShows[indexPath.row])
    }
}
