//
//  User.swift
//  Bevy
//
//  Created by macOS on 7/7/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class User: BaseObject {
    // User property
    var userID: String?
    var userType: String?
    var fullname: String?
    var email: String?
    var phone: String?
    var password: String?
    var birthday: Date?
    var creativeBarber: Bool?
    var creativeHairStylist: Bool?
    var creativeStylist: Bool?
    var creativeMakeup: Bool?
    var creativeBartender: Bool?
    var creativePrivateChef: Bool?
    var creativePhotographer: Bool?
    var creativePhysicalTrainer: Bool?

    override func mapping(map: Map) {
        super.mapping(map: map)
        userID                      <- map["userID"]
        userType                    <- map["userType"]
        fullname                    <- map["fullname"]
        email                       <- map["email"]
        password                    <- map["password"]
        phone                       <- map["phone"]
        birthday                    <- (map["birthday"], DateTransform.shared)
        creativeBarber              <- map["creativeBarber"]
        creativeHairStylist         <- map["creativeHairStylist"]
        creativeStylist             <- map["creativeStylist"]
        creativeMakeup              <- map["creativeMakeup"]
        creativeBartender           <- map["creativeBartender"]
        creativePrivateChef         <- map["creativePrivateChef"]
        creativePhotographer        <- map["creativePhotographer"]
        creativePhysicalTrainer     <- map["creativePhysicalTrainer"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let user = model as? User else { return }

        userID              = user.userID ?? userID
        userType            = user.userType ?? userType
        fullname            = user.fullname ?? fullname
        email               = user.email ?? email
        phone               = user.phone ?? phone
        password            = user.password ?? password
        birthday            = user.birthday ?? birthday
        creativeBarber            = user.creativeBarber ?? creativeBarber
        creativeHairStylist       = user.creativeHairStylist ?? creativeHairStylist
        creativeStylist           = user.creativeStylist ?? creativeStylist
        creativeMakeup            = user.creativeMakeup ?? creativeMakeup
        creativeBartender         = user.creativeBartender ?? creativeBartender
        creativePrivateChef       = user.creativePrivateChef ?? creativePrivateChef
        creativePhotographer      = user.creativePhotographer ?? creativePhotographer
        creativePhysicalTrainer   = user.creativePhysicalTrainer ?? creativePhysicalTrainer
    }
}
