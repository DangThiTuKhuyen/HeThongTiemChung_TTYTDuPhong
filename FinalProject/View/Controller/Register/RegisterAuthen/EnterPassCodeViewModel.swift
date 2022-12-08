//
//  EnterPassCodeViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 30/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class EnterPassCodeViewModel {

    var email: String
    private(set) var passCode: String = ""
    private(set) var password: String = ""
    private(set) var auth: Auth?

    init(email: String) {
        self.email = email
    }

    func setPassCode(value: String) {
        passCode = value
    }

    func setPassWord(value: String) {
        password = value
    }

    func addToken() {
        guard let auth = auth else { return }
        UserDefaults.standard.set(auth.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(auth.refreshToken, forKey: "refreshToken")
    }
}

extension EnterPassCodeViewModel {

    func createAccount(completion: @escaping APICompletion) {
        let params = AuthService.Account(email: email, passCode: passCode, newPassword: password)
        AuthService.confirmAccount(params: params) { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let auth):
                this.auth = auth
                this.addToken()
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
