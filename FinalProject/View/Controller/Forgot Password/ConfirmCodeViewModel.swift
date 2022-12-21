//
//  ConfirmCodeViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 07/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class ConfirmCodeViewModel {

    private(set) var email: String
    private(set) var confirmationCode: String = ""
    private(set) var newPassword: String = ""

    init(email: String) {
        self.email = email
    }

    func setConfirmationCode(value: String) {
        confirmationCode = value
    }

    func setNewPassWord(value: String) {
        newPassword = value
    }

    func resetPassword(completion: @escaping CompletionAPI) {
        let params = AuthService.Account(email: email, newPassword: newPassword, confirmationCode: confirmationCode)
        AuthService.resetPassword(params: params) { [weak self] result in
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
