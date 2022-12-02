//
//  HistoryService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 15/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

class HistoryService {

    static func getHistory(completion: @escaping Completion<[[History]]>) {
        let urlString = "http://3.92.194.85:3210/users/0879a9a2-5f65-4476-b107-fea78da2fd69/histories"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? Array<Any> {
                    guard let history = Mapper<History>().mapArrayOfArrays(JSONObject: data) else {
                        completion(.failure(Api.Error.json))
                        return
                    }
                    completion(.success(history))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
