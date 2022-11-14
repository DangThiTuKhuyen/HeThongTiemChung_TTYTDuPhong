//
//  Disease.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class Disease: Mappable {

    var diseaseId: Int?
    var diseaseName: String?
    var vaccines: [Vaccine]?

    required init?(map: Map) { }

    func mapping(map: Map) {
        diseaseId <- map["diseaseId"]
        diseaseName <- map["diseaseName"]
        vaccines <- map["vaccine"]
    }
}

final class Vaccine: Mappable {

    var vaccineId: Int?
    var vaccineName: String?
    var price: Float?
    var country: String?
    var effect: Int?
    var amount: Int?

    required init?(map: Map) { }

    func mapping(map: Map) {
        vaccineId <- map["vaccineId"]
        vaccineName <- map["vaccineName"]
        price <- map["price"]
        country <- map["country"]
        effect <- map["effect"]
        amount <- map["amount"]
    }
}

