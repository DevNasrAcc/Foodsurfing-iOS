//
//  StatisticsResp.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class StatisticsResp: Mappable {
    
    var error: String?
    var orders: [StatisticsOrder]?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error   <- map["error"]
        orders   <- map["order"]
    }
    
    //Inner Class
    class StatisticsOrder: Mappable {
        
        var id: String?
        var total_quantity: String?
        var total_price: String?
        var created_at: String?
        var customer_email: String?
        var customer_name: String?
        var currency: String?
        var meals: [OrderMeal]?
        var isExpanded: Bool = false
        
        
        required init?(map: Map) {
        }
        
        required init() {
        }
        
        // Mappable
        func mapping(map: Map) {
            id   <- map["id"]
            total_quantity  <- map["total_quantity"]
            total_price     <- map["total_price"]
            created_at      <- map["created_at"]
            customer_email  <- map["customer_email"]
            customer_name   <- map["customer_name"]
            currency        <- map["currency"]
            meals           <- map["meals"]
        }
        
        //Inner Class
        class OrderMeal: Mappable {
            
            var quantity: String?
            var price: String?
            var meal_title: String?
            var restaurant_id: String?
            
            required init?(map: Map) {
            }
            
            required init() {
            }
            
            // Mappable
            func mapping(map: Map) {
                quantity        <- map["quantity"]
                price           <- map["price"]
                meal_title      <- map["meal_title"]
                restaurant_id   <- map["restaurant_id"]
            }
        } //OrderMeal
        
    } //StatisticsOrder
    
}
