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

    struct Params {
        var diseaseId: Int
        var vaccineId: Int
        var medicalCenterId: Int
        var dose: Int
        var time: String

        init(diseaseId: Int, vaccineId: Int, medicalCenterId: Int, dose: Int, time: String
        ) {
            self.diseaseId = diseaseId
            self.vaccineId = vaccineId
            self.medicalCenterId = medicalCenterId
            self.dose = dose
            self.time = time
        }

        func toJSON() -> [String: Any] {
            var json: [String: Any] = [:]
            json["diseaseId"] = diseaseId
            json["vaccineId"] = vaccineId
            json["medicalCenterId"] = medicalCenterId
            json["registrationDose"] = dose
            json["registrationTime"] = time
            return json
        }
    }

    static func getDisease(completion: @escaping Completion<[Disease]>) {
        let urlString = Api.Path.userIdURL + "/diseases"
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

    static func getMedicalCenter(completion: @escaping Completion<[MedicalCenter]>) {
        let urlString = Api.Path.baseURL + "medical-center"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSArray {
                    var response: [MedicalCenter] = []
                    response = Mapper<MedicalCenter>().mapArray(JSONArray: data)
                    completion(.success(response))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func registerVaccine(params: Params, completion: @escaping APICompletion) {
        let url = Api.Path.userIdURL + "/registrations"
        api.request(method: .post, urlString: url, parameters: params.toJSON()) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject, let message = data["message"] as? String, message == "OK" {
                    completion(.success)
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getRegistration(completion: @escaping Completion<[Registration]>) {
        let urlString = Api.Path.userIdURL + "/registrations/getOne"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSArray {
                    var response: [Registration] = []
                    response = Mapper<Registration>().mapArray(JSONArray: data)
                    completion(.success(response))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    static func deleteRegistration(id: Int, completion: @escaping APICompletion) {
        let urlString = Api.Path.userIdURL + "/registrations/\(id)"
        api.request(method: .delete, urlString: urlString) { result in
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
    ///users/:userId/registrations/:id/update
    static func updateRegistration(id: Int, params: Params, completion: @escaping APICompletion) {
        let urlString = Api.Path.userIdURL + "/registrations/\(id)/update"
        api.request(method: .put, urlString: urlString) {  result in
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
//        guard let url = URL(string: urlString) else { return }
//        let jsonData = try? JSONSerialization.data(withJSONObject: params.toJSON())
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(.failure(Api.Error.json))
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            guard let responseJSON = responseJSON as? JSObject, let message = responseJSON["message"] as? String, message == "OK" else {
//                completion(.failure(Api.Error.json))
//                return
//            }
//            completion(.success)
//        }
//        task.resume()
    }
}
