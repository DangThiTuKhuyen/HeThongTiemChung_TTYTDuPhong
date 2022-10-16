//
//  AddressService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

class AddressService {

    // MARK: - Public func
    static func getProvince(completion: @escaping Completion<[Address]>) {
        api.request(method: .get, urlString: "https://provinces.open-api.vn/api/?depth=2") { result in
            switch result {
            case .success(let data):
                if let data = data as? JSArray {
                    let addresses = Mapper<Address>().mapArray(JSONArray: data)
                    completion(.success(addresses))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
