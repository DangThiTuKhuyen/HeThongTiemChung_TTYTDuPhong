//
//  AuthService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 29/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class AuthService {

    struct ConfirmAccount {
        var email: String
        var passCode: String
        var password: String

        init(email: String, passCode: String, password: String) {
            self.email = email
            self.passCode = passCode
            self.password = password
        }

        func toJSON() -> [String: Any] {
            var json: [String: Any] = [:]
            json["email"] = email
            json["tempPassword"] = passCode
            json["newPassword"] = password
            return json
        }
    }
    
    struct Account {
        var email: String
        var name: String?
        var identityCard: Int?
        var birthday: String?
        var province: String?
        var district: String?
        var phone: Int?
        var gender: String?
        

        init(email: String, name: String? = nil, identityCard: Int? = nil, birthday: String? = nil, province: String? = nil, district: String? = nil, phone: Int? = nil, gender: String? = nil) {
            self.email = email
            self.name = name
            self.identityCard = identityCard
            self.birthday = birthday
            self.province = province
            self.district = district
            self.phone = phone
            self.gender = gender
        }

        func toJSON() -> [String: Any] {
            var json: [String: Any] = [:]
            json["email"] = email
            if let name = name {
                json["userName"] = name
            }
            if let identityCard = identityCard {
                json["identityCard"] = identityCard
            }
            if let birthday = birthday {
                json["birthday"] = birthday
            }
            if let province = province {
                json["province"] = province
            }
            if let district = district {
                json["district"] = district
            }
            if let phone = phone {
                json["phone"] = phone
            }
            if let gender = gender {
                json["gender"] = gender
            }
            return json
        }
    }

    static func registerAccount(params: Account, completion: @escaping CompletionAPI) {
        let urlString = "http://3.92.194.85:3210/auth/registerAccount"
//        if let json = response.result.value as? JSObject
        api.request(method: .post, urlString: urlString, parameters: params.toJSON()) { result in
            switch result {
            case .success(let data):
                guard let data = data as? JSObject else { return }
                if let status = data["registerAccountStatus"] as? Bool, status == true {
                    completion(.success)
                    return
                } else {
                    completion(.failure(data["message"] as? String ?? Api.Error.json.localizedDescription))
                }
            case .failure(let error):
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
        }
    }

    static func confirmAccount(params: ConfirmAccount, completion: @escaping Completion<Auth>) {
        let urlString = "http://3.92.194.85:3210/auth/confirmRegisterAccount"
        api.request(method: .post, urlString: urlString, parameters: params.toJSON()) {  result in
            switch result {
            case .success(let data):
                guard let data = data as? JSObject else {
                    completion(.failure(Api.Error.json))
                    return
                }
                guard let auth = Mapper<Auth>().map(JSON: data) else {
                    completion(.failure(Api.Error.json))
                    return
                }
                completion(.success(auth))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
//
//        guard let url = URL(string: "http://3.92.194.85:3210/auth/confirmRegisterAccount") else { return }
//        let jsonData = try? JSONSerialization.data(withJSONObject: params.toJSON())
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(.failure(Api.Error.json.localizedDescription))
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            guard let responseJSON = responseJSON as? JSObject else { return }
//            if let status = responseJSON["registerAccountStatus"] as? Bool, status == true {
//                completion(.success)
//                return
//            } else {
//                completion(.failure(responseJSON["message"] as? String ?? Api.Error.json.localizedDescription))
//            }
//        }
//        task.resume()
    }
}
