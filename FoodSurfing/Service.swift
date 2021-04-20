//
//  Service.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation

enum Service {
    case login
    case register
    case fbLogin
    case statistics
    case filteredStatistics
    case settings
    case profile
    case updateProfile
    case todayBooking
    case updatePickupTime
    case updateMealQty
    case cancelOrder
    case restaurants
    case restMeals
    case mealDetails
    case nearbyRestaurants
    case markFav
    case favMeals
    case filteredRestaurants
    case createOrder
    case getOrders
    case postStripePayment
    case forgotPassword
}
