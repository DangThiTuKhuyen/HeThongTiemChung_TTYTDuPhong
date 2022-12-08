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
        let urlString = "http://3.92.194.85:3210/users/3dae9fab-bd33-4705-8a1f-aac4029c615f/registrations/appointment"
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

