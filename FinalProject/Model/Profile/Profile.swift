//
//  Profile.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 11/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class Profile: Mappable {

    var image: String?
    var name: String?
    var birthday: String?
    var gender: String?
    var province: String?
    var district: String?
    var email: String?
    var phone: Int?
    var identityCard: Int?

    required init?(map: Map) { }

    func mapping(map: Map) {
        image <- map["image"]
        name <- map["name"]
        birthday <- map["birthday"]
        gender <- map["gender"]
        province <- map["province"]
        district <- map["district"]
        email <- map["email"]
        phone <- map["phone"]
        identityCard <- map["identityCard"]
    }
}
