//
//  Auth.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 01/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

final class Auth: Object, Mappable {

    @objc dynamic var refreshToken: String?
    @objc dynamic var idToken: String?
    @objc dynamic var accessToken: String?
    
    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        refreshToken <- map["refreshToken"]
        idToken <- map["idToken"]
        accessToken <- map["accessToken"]
    }
}
