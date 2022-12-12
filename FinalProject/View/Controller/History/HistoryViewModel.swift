//
//  HistoryViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class HistoryViewModel {


    private(set) var histories: [[History]]?
    private(set) var keys: [String] = []

    func isShowTableView() -> Bool {
        return histories?.isNotEmpty ?? false
    }

    func getHistorySelected(at indexPath: IndexPath) -> [History] {
        return histories?[indexPath.row] ?? []

    }

    func numberOfRowInSection() -> Int {
        return histories?.count ?? 0
    }

    func viewModelForItem(at indexPath: IndexPath) -> HistoryCellViewModel {
        return HistoryCellViewModel(histories: histories?[indexPath.row] ?? [])
    }
}

extension HistoryViewModel {

    func getHistory(completion: @escaping APICompletion) {
        HistoryService.getHistory { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let histories):
                this.histories = histories
//                this.keys = histories.allKeys
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
