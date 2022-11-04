//
//  DetailHistoryViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

class DetailHistoryViewModel {
    
    var isShows = [Bool](repeating: false, count: 3)
    
    func viewModelForItem(at indexPath: IndexPath) -> DetailHistoryCellViewModel {
        return DetailHistoryCellViewModel(isShow: isShows[indexPath.row])
    }
}
