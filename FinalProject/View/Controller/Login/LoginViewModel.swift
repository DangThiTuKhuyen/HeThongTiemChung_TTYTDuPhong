//
//  LoginViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 02/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class LoginViewModel {
    
    private(set) var email: String = ""
    private(set) var password: String = ""
    private(set) var auth: Auth?
    
    func setEmai(value: String) {
        email = value
    }
    
    func setPassWord(value: String) {
        password = value
    }
    
    func addToken() {
        guard let auth = auth else { return }
        UserDefaults.standard.set(auth.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(auth.refreshToken, forKey: "refreshToken")
        UserDefaults.standard.set(auth.userId, forKey: "userId")
        UserDefaults.standard.set(auth.userName, forKey: "userName")
        UserDefaults.standard.set(auth.email, forKey: "email")
    }
}

extension LoginViewModel {
    
    func login(completion: @escaping CompletionAPI) {
        let params = AuthService.Account(email: email, password: password)
        AuthService.login(params: params) { [weak self] (data, error) in
            guard let this = self else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            if let data = data, error == nil {
                this.auth = data
                this.addToken()
                completion(.success)
            } else {
                completion(.failure(error ?? Api.Error.json.localizedDescription))
            }
            completion(.failure(Api.Error.json.localizedDescription))
        }
    }
}
