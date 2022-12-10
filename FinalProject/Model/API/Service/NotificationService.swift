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
    
    static func getNotify(completion: @escaping Completion<[Notify]>) {
        let urlString = "http://3.92.194.85:3210/user/0879a9a2-5f65-4476-b107-fea78da2fd69/notification"
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
}
