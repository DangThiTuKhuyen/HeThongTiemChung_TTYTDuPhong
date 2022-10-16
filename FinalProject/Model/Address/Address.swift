//
//  Address.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

class Address: Mappable {

    var province: String = ""
    var districts: [District] = []

    required init?(map: Map) { }

    func mapping(map: Map) {
        province <- map["name"]
        districts <- map["districts"]
    }
}
