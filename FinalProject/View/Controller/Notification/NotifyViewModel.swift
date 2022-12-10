//
//  NotifyViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 06/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class NotifyViewModel {

    private(set) var notities: [Notify] = []

    func numberOfRowInSection() -> Int {
        return notities.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> NotifyCellViewModel {
        return NotifyCellViewModel(notify: notities[indexPath.row])
    }

    func getNotify(completion: @escaping APICompletion) {
        NotifycationService.getNotify { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let data):
                this.notities = data
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
