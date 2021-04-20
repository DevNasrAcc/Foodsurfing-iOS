//
//  CreateOrderResp.swift
//  Foodsurfing
//
//  Created by developer on 20/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class CreateOrderResp: Mappable {
    
    var error: String?
    var user_order: String?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error        <- map["error"]
        user_order   <- map["user_order"]
    }
}
