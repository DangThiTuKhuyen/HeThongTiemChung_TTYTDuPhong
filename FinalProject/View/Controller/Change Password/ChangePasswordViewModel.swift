//
//  ChangePasswordViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class ChangePasswordViewModel {

    private(set) var oldPass: String = ""
    private(set) var newPass: String = ""

    func setOldPass(value: String) {
        oldPass = value
    }

    func setNewPass(value: String) {
        newPass = value
    }
}

extension ChangePasswordViewModel {

    func changePass(completion: @escaping CompletionAPI) {
        let params = AuthService.Account(newPassword: newPass, oldPassword: oldPass, accessToken: UserDefaults.standard.string(forKey: "accessToken"))
        AuthService.changePass(params: params) { [weak self] result in
            guard self != nil else {
                completion(.failure(Api.Error.json.localizedDescription))
                return }
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
