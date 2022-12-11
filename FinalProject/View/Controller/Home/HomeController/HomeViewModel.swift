//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import SwiftUtils

final class HomeViewModel {

    func getCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
}

// MARK: - API
extension HomeViewModel {

    func getProfile(completion: @escaping Completion<Profile>) {
        ProfileService.getProfile { [weak self] result in
            guard let this = self else { return completion(.failure(Api.Error.json)) }
            switch result {
            case .success(let profile):
                Api.Profile.name = profile.name ?? ""
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
