//
//  RestaurantsResp.swift
//  Foodsurfing
//
//  Created by developer on 13/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class RestaurantsResp: Mappable {
    
    var error: String?
    var restaurants: [Restaurant]?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error           <- map["error"]
        restaurants     <- map["restaurants"]
    }
    
}
