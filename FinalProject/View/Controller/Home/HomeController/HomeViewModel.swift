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

    func getAvatarImage(completion: @escaping Completion<String>) {
        ProfileService.getAvatarImage { [weak self] result in
            guard self != nil else { return completion(.failure(Api.Error.json)) }
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
