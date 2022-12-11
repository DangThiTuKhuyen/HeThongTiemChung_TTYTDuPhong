//
//  Auth.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 01/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

final class Auth: Mappable {

    var refreshToken: String?
    var accessToken: String?
    var email: String?
    var userName: String?
    var userId: String?

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        refreshToken <- map["refreshToken"]
        accessToken <- map["accessToken"]
        email <- map["email"]
        userName <- map["userName"]
        userId <- map["userId"]
    }
}
