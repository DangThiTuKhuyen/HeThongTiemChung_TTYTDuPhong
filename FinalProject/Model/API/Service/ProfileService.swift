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
        let urlString = "http://3.92.194.85:8080/"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject {
                    guard let profile = Mapper<Profile>().map(JSONObject: data) else {
                        return completion(.failure(Api.Error.json))
                    }
                    completion(.success(profile))
//                    var venue: [SimilarVenue] = []
//                    venue = Mapper<SimilarVenue>().mapArray(JSONArray: items)
//                    completion(.success(venue))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
