//
//  ForgotPasswordViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 07/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class ForgotPasswordViewModel {

    private(set) var email: String = ""

    func setEmail(value: String) {
        email = value
    }

    func forgotPassword(completion: @escaping CompletionAPI) {
        let params = AuthService.Account(email: email)
        AuthService.forgotPassword(params: params) { [weak self] result in
            guard self != nil else {
                completion(.failure(Api.Error.json.localizedDescription))
                return
            }
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
