//
//  Notify.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 09/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

final class Notify: Mappable {

    var notifyTitle: String?
    var notifyContent: String?
    var time: String?
    var titleType: String?
    var status: Bool = false

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        notifyTitle <- map["notificationTitle"]
        notifyContent <- map["notificationContent"]
        time <- map["createdAt"]
        titleType <- map["notificationType"]
        status <- map["notificationStatus"]
    }
}
