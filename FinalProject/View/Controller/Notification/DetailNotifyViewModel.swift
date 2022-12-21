//
//  DetailNotifyViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 17/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class DetailNotifyViewModel {

    private(set) var notify: Notify

    init(notify: Notify) {
        self.notify = notify
    }

    func updateStatus(completion: @escaping APICompletion) {
        let params = NotifycationService.Notification(notifycationId: [notify.id])
        NotifycationService.updateStatus(parameters: params) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
