//
//  Constants.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation

class Constants {
    
    //Basics
    static let serverUrl = "http://foodsurfing.eu/api/"
    
    //Keys
    static let tokenKey = "USER_TOKEN"
    static let userIdKey = "USER_ID"
    static let userRole = "USER_ROLE"
    
    //Tags
    static let tagTransLayer = 101
    
    //Notifications
    static let notifTagRestDataChange = "com.adeel.foodsurfing.RestaurantsDataUpdate"
    static let notifTagHomeControllerChange = "com.adeel.foodsurfing.ChildControllerChanged"
    
    //Colors
    static let primaryColor: UIColor = Helper.hexStringToUIColor(hex: "D61A6A")
    static let dotGreyColor: UIColor = UIColor.darkGray
}
