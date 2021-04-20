//
//  SettingsResp.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class SettingsResp: Mappable {
    
    var error: String?
    var restaurant: RestaurantInfo?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error   <- map["error"]
        restaurant   <- map["restaurant"]
    }
    
    
    //Inner Class
    class RestaurantInfo: Mappable {
        
        var id: String?
        var name: String?
        var description: String?
        var currency: String?
        var logo: String?
        var startTime: String?
        var endTime: String?
        
        var restaurant_meals: [RestaurantMeal]?
        
        required init?(map: Map) {
        }
        
        required init() {
        }
        
        // Mappable
        func mapping(map: Map) {
            id                  <- map["id"]
            name                <- map["name"]
            description         <- map["description"]
            currency            <- map["currency"]
            logo                <- map["logo"]
            startTime           <- map["start_pickup_time"]
            endTime             <- map["end_pickup_time"]
            restaurant_meals    <- map["restaurant_meals"]
        }
        
        //Inner Class
        class RestaurantMeal: Mappable {
            
            var id: String?
            var title: String?
            var description: String?
            var quantity: String?
            var price: String?
            var image: String?
            
            required init?(map: Map) {
            }
            
            required init() {
            }
            
            // Mappable
            func mapping(map: Map) {
                id              <- map["id"]
                title           <- map["title"]
                description     <- map["description"]
                quantity        <- map["quantity"]
                price           <- map["price"]
                image           <- map["image"]
            }
        } //RestaurantMeal
        
    } //RestaurantInfo
    
}
