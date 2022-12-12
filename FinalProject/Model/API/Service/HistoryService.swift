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
        let urlString = Api.Path.userIdURL + "/histories"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? Array<Any> {
                    guard !data.isEmpty else {
                        completion(.success([]))
                        return
                    }
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
