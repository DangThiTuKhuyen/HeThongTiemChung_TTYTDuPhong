//
//  AppointmentService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

class AppointmentService {

    static func getAppointment(completion: @escaping Completion<[Registration]>) {
        let urlString = Api.Path.userIdURL + "/registrations/appointment"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSArray {
                    let appointments = Mapper<Registration>().mapArray(JSONArray: data)
                    completion(.success(appointments))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

