//
//  RegistrationVaccineService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

class RegistrationVaccineService {

    static func getDisease(completion: @escaping Completion<[Disease]>) {
        let urlString = "http://3.92.194.85:8081/"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSArray {
                    var response: [Disease] = []
                    response = Mapper<Disease>().mapArray(JSONArray: data)
                    completion(.success(response))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
