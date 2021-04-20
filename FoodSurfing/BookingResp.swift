//
//  BookingResp.swift
//  Foodsurfing
//
//  Created by developer on 24/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class BookingResp: Mappable {
    
    var error: String?
    var orders: [TodayOrder]?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error   <- map["error"]
        orders   <- map["order"]
    }
    
    //Inner class
    class TodayOrder: Mappable {
        var id: String?
        var total_quantity: String?
        var total_price: String?
        var pickup_time: String?
        var currency: String?
        var customer_name: String?
        var meals: [Meal]?
        var isExpanded: Bool = false
        
        required init?(map: Map) {
        }
        
        required init() {
        }
        
        // Mappable
        func mapping(map: Map) {
            id   <- map["id"]
            total_quantity   <- map["total_quantity"]
            total_price   <- map["total_price"]
            pickup_time   <- map["pickup_time"]
            currency   <- map["currency"]
            customer_name   <- map["customer_name"]
            meals   <- map["meals"]
        }
        
        //Inner Class
        class Meal: Mappable {
            var meal_id: String?
            var quantity: String?
            var price: String?
            var meal_title: String?
            var meal_description: String?
            var restaurant_name: String?
            var restaurant_description: String?
            var restaurant_opening_time: String?
            var restaurant_closing_time: String?
            var restaurant_address: String?
            var currency: String?
            
            required init?(map: Map) {
            }
            
            required init() {
            }
            
            // Mappable
            func mapping(map: Map) {
                meal_id   <- map["meal_id"]
                quantity   <- map["quantity"]
                price   <- map["price"]
                meal_title   <- map["meal_title"]
                meal_description   <- map["meal_description"]
                restaurant_name   <- map["restaurant_name"]
                restaurant_description   <- map["restaurant_description"]
                restaurant_opening_time   <- map["restaurant_opening_time"]
                restaurant_closing_time   <- map["restaurant_closing_time"]
                restaurant_address   <- map["restaurant_address"]
                currency   <- map["currency"]
            }
        } //Meal
    } //TodayOrder
}// BookingResp
