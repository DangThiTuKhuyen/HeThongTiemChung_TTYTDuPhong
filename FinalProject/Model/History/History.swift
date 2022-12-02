//
//  History.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 26/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

final class History: Mappable {

    var historyId: Int?
    var time: String?
    var dose: Int?
    var disease: Disease?
    var medicalCenter: MedicalCenter?

    required init?(map: Map) { }

    func mapping(map: Map) {
        historyId <- map["historyId"]
        time <- map["time"]
        dose <- map["dose"]
        disease <- map["disease"]
        medicalCenter <- map["medicalCenter"]
    }
}
