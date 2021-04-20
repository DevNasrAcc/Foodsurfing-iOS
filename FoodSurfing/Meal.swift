//
//  Meal.swift
//  Foodsurfing
//
//  Created by developer on 13/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class Meal: Mappable {
    var id: String?
    var title: String?
    var description: String?
    var quantity: String?
    var price: String?
    var restaurant_id: String?
    var status: String?
    var created_at: String?
    var updated_at: String?
    var restaurant_name: String?
    var pickup_time: String?
    var meal_id: String?
    var user_id: String?
    var currency: String?
    var meal_image: String?
    var is_favorite: Bool?
    var opening_time: String?
    var closing_time: String?
    var img: String?
    var qtySelected: String?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        id   <- map["id"]
        title   <- map["title"]
        description   <- map["description"]
        quantity   <- map["quantity"]
        price   <- map["price"]
        restaurant_id   <- map["restaurant_id"]
        status   <- map["status"]
        created_at   <- map["created_at"]
        updated_at   <- map["updated_at"]
        restaurant_name   <- map["restaurant_name"]
        pickup_time   <- map["pickup_time"]
        meal_id   <- map["meal_id"]
        user_id   <- map["user_id"]
        currency   <- map["currency"]
        meal_image   <- map["meal_image"]
        is_favorite   <- map["is_favorite"]
        opening_time   <- map["opening_time"]
        closing_time   <- map["closing_time"]
        img   <- map["img"]
    }
} //Meal
