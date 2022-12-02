//
//  User.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 17/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

final class User: Object, Mappable {

    @objc dynamic var id: Int = 0
    @objc dynamic var accessToken: String = ""
    @objc dynamic var refreshToken: String = ""
    @objc dynamic var tokenId: String = ""
    
    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["summary"]
    }
}
