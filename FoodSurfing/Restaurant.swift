//
//  Restaurant.swift
//  Foodsurfing
//
//  Created by developer on 13/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class Restaurant: Mappable {
    
    var id: String?
    var email: String?
    var name: String?
    var contact_person: String?
    var address: String?
    var description: String?
    var postal: String?
    var phone: String?
    var opening_time: String?
    var closing_time: String?
    var pickup_time: String?
    var image_id: String?
    var pickup: String?
    var img: String?
    var logo: String?
    var latitude: String?
    var longitude: String?
    var distance: String?
    var marker_icon: String?
    var availability: String?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        id   <- map["id"]
        email   <- map["email"]
        name   <- map["name"]
        contact_person   <- map["contact_person"]
        address   <- map["address"]
        description   <- map["description"]
        postal   <- map["postal"]
        phone   <- map["phone"]
        opening_time   <- map["opening_time"]
        closing_time   <- map["closing_time"]
        pickup_time   <- map["pickup_time"]
        image_id   <- map["image_id"]
        pickup   <- map["pickup"]
        img   <- map["img"]
        logo   <- map["logo"]
        latitude   <- map["latitude"]
        longitude   <- map["longitude"]
        distance   <- map["distance"]
        marker_icon   <- map["marker_icon"]
        availability <- map["availability"]
    }
}
