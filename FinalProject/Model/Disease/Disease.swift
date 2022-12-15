//
//  Disease.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

final class Disease: Mappable {

    var diseaseId: Int?
    var diseaseName: String?
    var treatments: [Treatment]?
    var diseaseDescribe: String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        diseaseId <- map["diseaseId"]
        diseaseName <- map["diseaseName"]
        treatments <- map["treatments"]
        diseaseDescribe <- map["diseaseDescribe"]
    }
}

final class Treatment: Mappable {

    var diseaseId: Int?
    var vaccineId: Int?
    var effect: Int?
    var amount: Int?
    var vaccine: Vaccine?

    required init?(map: Map) { }

    func mapping(map: Map) {
        diseaseId <- map["diseaseId"]
        vaccineId <- map["vaccineId"]
        effect <- map["effect"]
        amount <- map["amount"]
        vaccine <- map["vaccine"]
    }
}

final class Vaccine: Mappable {

    var vaccineId: Int?
    var vaccineName: String?
    var vaccinePrice: Float?
    var country: String?
    var firm: String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        vaccineId <- map["vaccineId"]
        vaccineName <- map["vaccineName"]
        vaccinePrice <- map["vaccinePrice"]
        country <- map["country"]
        firm <- map["vaccineFirm"]
    }
}
