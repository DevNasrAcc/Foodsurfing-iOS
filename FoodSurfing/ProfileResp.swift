//
//  ProfileResp.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileResp: Mappable {
    
    var error: String?
    var user: User?
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    // Mappable
    func mapping(map: Map) {
        error   <- map["error"]
        user   <- map["user"]
    }
    
    //Inner class
    class User: Mappable {
        
        var id: String?
        var email: String?
        var firstname: String?
        var lastname: String?
        var gender: String?
        var birthdate: String?
        var street_name: String?
        var postal: String?
        var city: String?
        var region: String?
        var country: String?
        var social_user: String?
        var social_user_id: String?
        var image_id: String?
        var status: String?
        var user_image: String?
        
        required init?(map: Map) {
        }
        
        required init() {
        }
        
        // Mappable
        func mapping(map: Map) {
            id   <- map["id"]
            email   <- map["email"]
            firstname   <- map["firstname"]
            lastname   <- map["lastname"]
            gender   <- map["gender"]
            birthdate   <- map["birthdate"]
            street_name   <- map["street_name"]
            postal   <- map["postal"]
            city   <- map["city"]
            region   <- map["region"]
            country   <- map["country"]
            social_user   <- map["social_user"]
            social_user_id   <- map["social_user_id"]
            image_id   <- map["image_id"]
            status   <- map["status"]
            user_image   <- map["user_image"]
            
        }
    } //User
    
}
