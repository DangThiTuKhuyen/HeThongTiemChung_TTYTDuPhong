//
//  District.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

class District: Mappable {

    var districts: String = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        districts <- map["name"]
    }
}
