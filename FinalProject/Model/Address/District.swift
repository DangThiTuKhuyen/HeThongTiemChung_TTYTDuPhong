//
//  District.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

final class District: Mappable {

    var name: String = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        name <- map["name"]
    }
}
