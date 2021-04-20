//
//  MealDetailResp.swift
//  Foodsurfing
//
//  Created by developer on 13/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class MealDetailResp: Mappable {
    
    var error: String?
    var mealDetails: [MealDetail]?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error          <- map["error"]
        mealDetails     <- map["restaurant_meal_detail"]
    }
    
    //Inner Class
    class MealDetail: Mappable {
        
        var title: String?
        var description: String?
        
        required init?(map: Map) {
        }
        
        required init() {
        }
        
        // Mappable
        func mapping(map: Map) {
            title           <- map["title"]
            description     <- map["description"]
        }
    }
    
}
