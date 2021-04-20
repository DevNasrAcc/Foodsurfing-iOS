//
//  LoginResp.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResp: Mappable {
    
    var error: String?
    var token: String?
    var user_id: String?
    var role: String?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error   <- map["error"]
        token   <- map["token"]
        user_id <- map["user_id"]
        role    <- map["role"]
    }
}
