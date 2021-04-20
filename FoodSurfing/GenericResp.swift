//
//  GenericResp.swift
//  Foodsurfing
//
//  Created by developer on 24/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class GenericResp: Mappable {
    
    var error: String?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error   <- map["error"]
    }
}
