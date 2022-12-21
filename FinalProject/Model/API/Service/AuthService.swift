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
import SwiftUtils

class AuthService {

    struct Account {
        var email: String?
        var name: String?
        var identityCard: Int?
        var birthday: String?
        var province: String?
        var district: String?
        var phone: Int?
        var gender: String?
        var passCode: String?
        var newPassword: String?
        var password: String?
        var oldPassword: String?
        var accessToken: String?
        var confirmationCode: String?

        init(email: String? = nil, name: String? = nil, identityCard: Int? = nil, birthday: String? = nil, province: String? = nil, district: String? = nil, phone: Int? = nil, gender: String? = nil, passCode: String? = nil, newPassword: String? = nil, password: String? = nil, oldPassword: String? = nil, accessToken: String? = nil, confirmationCode: String? = nil) {
            self.email = email
            self.name = name
            self.identityCard = identityCard
            self.birthday = birthday
            self.province = province
            self.district = district
            self.phone = phone
            self.gender = gender
            self.newPassword = newPassword // register
            self.passCode = passCode
            self.password = password // login
            self.oldPassword = oldPassword // changePass
            self.accessToken = accessToken
            self.confirmationCode = confirmationCode
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
            if let newPassword = newPassword {
                json["newPassword"] = newPassword
            }
            if let passCode = passCode {
                json["tempPassword"] = passCode
            }
            if let password = password {
                json["password"] = password
            }
            if let oldPassword = oldPassword {
                json["oldPassword"] = oldPassword
            }
            if let accessToken = accessToken {
                json["accessToken"] = accessToken
            }

            if let confirmationCode = confirmationCode {
                json["confirmationCode"] = confirmationCode
            }
            return json
        }
    }

    static func registerAccount(params: Account, completion: @escaping CompletionAPI) {
        let urlString = Api.Path.authURL + "registerAccount"
//        if let json = response.result.value as? JSObject
        guard let url = URL(string: urlString) else { return }
        let jsonData = try? JSONSerialization.data(withJSONObject: params.toJSON())
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let responseJSON = responseJSON as? JSObject else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            if let status = responseJSON["registerAccountStatus"] as? Bool, status == true {
                completion(.success)
            } else {
                completion(.failure(responseJSON["message"] as? String ?? Api.Error.json.localizedDescription))
            }
        }
        task.resume()
    }

    static func confirmAccount(params: Account, completion: @escaping (_ data: Auth?, _ error: String?) -> Void) {
        let urlString = Api.Path.authURL + "confirmRegisterAccount"
        guard let url = URL(string: urlString) else { return }
        let jsonData = try? JSONSerialization.data(withJSONObject: params.toJSON())
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, Api.Error.json.localizedDescription)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let responseJSON = responseJSON as? JSObject, let message = responseJSON["message"] as? String else {
                completion(nil, Api.Error.json.localizedDescription)
                return
            }
            if message == "success" {
                guard let auth = Mapper<Auth>().map(JSON: responseJSON) else {
                    completion(nil, Api.Error.json.localizedDescription)
                    return
                }
                completion(auth, nil)
            } else {
                completion(nil, message)
            }
        }
        task.resume()
    }

    static func refreshToken(completion: @escaping (Bool) -> Void) {
        let urlString = Api.Path.authURL + "refreshToken"
        guard let url = URL(string: urlString) else { return }
        let params = ["refreshToken": UserDefaults.standard.string(forKey: "refreshToken") ?? ""]
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let error = error, error.code == 500 else {
                completion(false)
                return
            }
            guard let responseJSON = responseJSON as? JSObject, let auth = Mapper<Auth>().map(JSON: responseJSON) else {
                completion(false)
                return
            }
            UserDefaults.standard.set(auth.accessToken, forKey: "accessToken")
            UserDefaults.standard.set(auth.refreshToken, forKey: "refreshToken")
            completion(true)
        }
        task.resume()

//        api.request(method: .post, urlString: urlString, parameters: ["refreshToken": UserDefaults.standard.string(forKey: "refreshToken") ?? ""]) { result in
//            switch result {
//            case .success(let data):
//                guard let data = data as? JSObject, let auth = Mapper<Auth>().map(JSON: data) else {
//                    completion(false)
//                    return
//                }
//                    UserDefaults.standard.set(auth.accessToken, forKey: "accessToken")
//                    UserDefaults.standard.set(auth.refreshToken, forKey: "refreshToken")
//                completion(true)
//            case .failure(let error):
//                completion(false)
//                return
//            }
//        }
    }

    static func updateProfile(params: Account, completion: @escaping (Bool) -> Void) {
        let urlString = Api.Path.userIdURL
        api.request(method: .put, urlString: urlString, parameters: params.toJSON()) { result in
            switch result {
            case .success(let data):
                guard let data = data as? JSObject, let message = data["message"] as? String, message == "Update Success" else {
                    completion(false)
                    return
                }
                completion(true)
            case .failure(let _):
                completion(false)
                return
            }
        }
    }

    static func login(params: Account, completion: @escaping (_ data: Auth?, _ error: String?) -> Void) {
        let urlString = Api.Path.authURL + "loginUsers"
        guard let url = URL(string: urlString) else { return }
        let jsonData = try? JSONSerialization.data(withJSONObject: params.toJSON())
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, Api.Error.json.localizedDescription)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let responseJSON = responseJSON as? JSObject, let message = responseJSON["message"] as? String else {
                completion(nil, Api.Error.json.localizedDescription)
                return
            }
            if message == "success" {
                guard let auth = Mapper<Auth>().map(JSON: responseJSON) else {
                    completion(nil, Api.Error.json.localizedDescription)
                    return
                }
                completion(auth, nil)
            } else {
                completion(nil, message)
            }
        }
        task.resume()
    }

    static func changePass(params: Account, completion: @escaping CompletionAPI) {
        let urlString = Api.Path.authURL + "changePassword"
        api.request(method: .put, urlString: urlString, parameters: params.toJSON()) { result in
            switch result {
            case .success(let data):
                guard let data = data as? JSObject else {
                    completion(.failure(Api.Error.json.localizedDescription))
                    return
                }
                guard let message = data["changePasswordMessage"] as? String, message == "Success" else {
                    completion(.failure(data["message"] as? String ?? Api.Error.json.localizedDescription))
                    return
                }
                completion(.success)
            case .failure(let error):
                switch error.code {
                case 400:
                    completion(.failure("Invalid old password"))
                case 500:
                    completion(.failure("Attempt limit exceeded, please try again in 1 hour"))
                default:
                    completion(.failure(error.localizedDescription))
                }
//                return
            }
        }
    }

    static func forgotPassword(params: Account, completion: @escaping CompletionAPI) {
        let urlString = Api.Path.authURL + "forgotPassword"
//        if let json = response.result.value as? JSObject
        guard let url = URL(string: urlString) else { return }
        let jsonData = try? JSONSerialization.data(withJSONObject: params.toJSON())
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let responseJSON = responseJSON as? JSObject else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            if let message = responseJSON["forgotPasswordMessage"] as? String, message == "Success" {
                completion(.success)
            } else {
                completion(.failure(responseJSON["message"] as? String ?? Api.Error.json.localizedDescription))
            }
        }
        task.resume()
    }

    static func resetPassword(params: Account, completion: @escaping CompletionAPI) {
        let urlString = Api.Path.authURL + "resetPassword"
        guard let url = URL(string: urlString) else { return }
        let jsonData = try? JSONSerialization.data(withJSONObject: params.toJSON())
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let responseJSON = responseJSON as? JSObject else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            if let message = responseJSON["passwordResetMessage"] as? String, message == "Success" {
                completion(.success)
            } else {
                completion(.failure(responseJSON["message"] as? String ?? Api.Error.json.localizedDescription))
            }
        }
        task.resume()
    }

    static func logout(params: Account, completion: @escaping CompletionAPI) {
        let urlString = Api.Path.authURL + "logoutUser"
        api.request(method: .post, urlString: urlString, parameters: params.toJSON()) { result in
            switch result {
            case .success(let data):
                guard let data = data as? JSObject else {
                    completion(.failure(Api.Error.json.localizedDescription))
                    return
                }
                guard let message = data["logoutMessage"] as? String, message == "success" else {
                    completion(.failure(Api.Error.json.localizedDescription))
                    return
                }
                completion(.success)
            case .failure(let error):
                completion(.failure(error.localizedDescription))
                return
            }
        }
    }

    static func uploadImage(completion: @escaping Completion<String>) {
        let urlString = Api.Path.userIdURL + "/uploadImage"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                guard let data = data as? JSObject, let urlUpload = data["urlUpload"] as? String else {
                    completion(.failure(Api.Error.json))
                    return
                }
                completion(.success(urlUpload))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func uploadAWSS3(image: UIImage, urlUpload: String, completion: @escaping ((_ bool: Bool?) -> Void)) {
//        let header = ["Content-Type": "application/octet-stream"]
//        Alamofire.upload(multipartFormData: { multipartFormData in
////            multipartFormData.contentType = "image/png"
////            if let imageData = image.jpegData(compressionQuality: 1.0)
//            if let imageData = image.pngData() {
////                multipartFormData.append(imageData, withName: "image")
//                multipartFormData.append(imageData, withName: "", fileName: ".png", mimeType: "image/png")
//            }
//        }, usingThreshold: UInt64.init(), to: urlUpload, method: .put, headers: header, encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        print(response.result)
//                        completion(true)
//                    }
//                case .failure(let encodingError):
//                    completion(false)
//                }
//            }
//        )
        guard let url = URL(string: urlUpload) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        let data = image.jpegData(compressionQuality: 1.0)
        URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode, responseCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        }).resume()
    }
}
