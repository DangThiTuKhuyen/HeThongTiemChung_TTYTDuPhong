//
//  Registration.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 17/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

final class Registration: Mappable {

    var registrationId: Int?
    var status: Bool?
    var registrationTime: String?
    var registrationDose: Int?
    var medicalCenter: MedicalCenter?
    var vaccine: Vaccine?
    var disease: Disease?

    required init?(map: Map) { }

    func mapping(map: Map) {
        registrationId <- map["registrationId"]
        status <- map["status"]
        registrationTime <- map["registrationTime"]
        registrationDose <- map["registrationDose"]
        medicalCenter <- map["medicalCenter"]
        vaccine <- map["vaccine"]
        disease <- map["disease"]
    }
}

final class MedicalCenter: Mappable {
    var medicalCenterId: Int?
    var name: String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        medicalCenterId <- map["medicalCenterId"]
        name <- map["name"]
    }
}
