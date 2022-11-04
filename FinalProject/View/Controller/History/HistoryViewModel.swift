//
//  HistoryViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class HistoryViewModel {
    
    var diseases: [String] = []
    
    func numberOfRowInSection() -> Int {
        return diseases.count
    }
    
    func viewModelForItem(at indexPath: IndexPath) -> HistoryCellViewModel {
        return HistoryCellViewModel()
    }
}
