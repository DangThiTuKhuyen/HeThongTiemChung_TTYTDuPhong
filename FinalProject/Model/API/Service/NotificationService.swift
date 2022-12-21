//
//  NotificationService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 09/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

class NotifycationService {

    struct Notification {
        var notifycationId: [Int]
        init(notifycationId: [Int]) {
            self.notifycationId = notifycationId
        }

        func toJSON() -> [String: Any] {
            var json: [String: Any] = [:]
            json["notificationId"] = notifycationId
            return json
        }
    }

    static func getNotify(completion: @escaping Completion<[Notify]>) {
        let urlString = Api.Path.userIdURL + "/notification"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSArray {
                    let notifies = Mapper<Notify>().mapArray(JSONArray: data)
                    completion(.success(notifies))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func updateStatus(parameters: Notification, completion: @escaping APICompletion) {
        let urlString = Api.Path.userIdURL + "/notification"
        api.request(method: .put, urlString: urlString, parameters: parameters.toJSON()) { result in
            switch result {
            case .success(let data):
                guard let data = data as? JSObject, let message = data["message"] as? String, message == "OK" else {
                    completion(.failure(Api.Error.json))
                    return
                }
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }

        }
    }
}
