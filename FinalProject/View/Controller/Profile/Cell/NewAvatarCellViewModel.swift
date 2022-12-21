//
//  NewAvatarCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class NewAvatarCellViewModel {

    // MARK: - Properties
    private(set) var urlString: String?
    private(set) var type: ProfileType?

    // MARK: - Initial
    init(urlString: String?, type: ProfileType?) {
        self.urlString = urlString
        self.type = type
    }
}
