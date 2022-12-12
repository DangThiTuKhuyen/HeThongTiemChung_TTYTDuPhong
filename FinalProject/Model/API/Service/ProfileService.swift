//
//  ProfileService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 11/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileService {

    static func getProfile(completion: @escaping Completion<Profile>) {
        let urlString = Api.Path.userIdURL
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject {
                    guard let profile = Mapper<Profile>().map(JSONObject: data) else {
                        completion(.failure(Api.Error.json))
                        return
                    }
                    completion(.success(profile))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
