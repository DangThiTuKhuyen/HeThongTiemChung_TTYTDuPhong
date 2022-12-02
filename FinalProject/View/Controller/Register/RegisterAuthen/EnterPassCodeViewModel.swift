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

    func addToken(completion: APICompletion) {
        guard let auth = auth else { return }
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(Auth.self, value: auth, update: .all)
            }
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }
}

extension EnterPassCodeViewModel {

    func createAccount(completion: @escaping APICompletion) {
        let params = AuthService.ConfirmAccount(email: email, passCode: passCode, password: password)
        AuthService.confirmAccount(params: params) { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let auth):
                this.auth = auth
                this.addToken() { [weak self] result in
                    guard self != nil else {
                        completion(.failure(Realm.Error.self as! Error))
                        return }
                    switch result {
                    case .success:
                        completion(.success)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
