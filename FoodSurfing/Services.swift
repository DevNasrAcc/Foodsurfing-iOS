//
//  Services.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftKeychainWrapper

class Services {
    
    class func loginService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.login
        let url = Constants.serverUrl + "index/login/"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func fbLoginService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.fbLogin
        let url = Constants.serverUrl + "index/login/"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func registerService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.register
        let url = Constants.serverUrl + "index/register/"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func profileService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.profile
        let url = Constants.serverUrl + "user/get/"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func updateProfileService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.updateProfile
        let url = Constants.serverUrl + "user/updateProfile"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func settingsService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.settings
        let url = Constants.serverUrl + "restaurants/getRestaurantSettings"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func statisticsService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.statistics
        let url = Constants.serverUrl + "order/getRestaurantStatistics"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func filteredStatisticsService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.filteredStatistics
        let url = Constants.serverUrl + "order/getRestaurantFilteredStatistics"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func todayBookingService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.todayBooking
        let url = Constants.serverUrl + "order/getTodayBookings"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func updatePickupTimeService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.updatePickupTime
        let url = Constants.serverUrl + "restaurants/updateRestaurantPickupTime"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func updateMealQtyService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.updateMealQty
        let url = Constants.serverUrl + "restaurants/updateMealQuantity"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func cancelOrderService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.cancelOrder
        let url = Constants.serverUrl + "order/cancelOrder"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func getRestaurnatsService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.restaurants
        let url = Constants.serverUrl + "restaurants/get"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func getRestaurnatMealsService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.restMeals
        let url = Constants.serverUrl + "restaurants/getRestaurantMeals"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func getMealDetailsService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.mealDetails
        let url = Constants.serverUrl + "restaurants/getMealDetail"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func getNearByRestService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.nearbyRestaurants
        let url = Constants.serverUrl + "restaurants/getNearbyRestaurants"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func markFavouriteService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.markFav
        let url = Constants.serverUrl + "restaurants/mealFavourite"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func getFavouriteMealsService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.favMeals
        let url = Constants.serverUrl + "restaurants/getFavouriteMeals"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func getFilteredRestService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.filteredRestaurants
        let url = Constants.serverUrl + "restaurants/getFilteredRestaurants"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func createOrderService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.createOrder
        let url = Constants.serverUrl + "order/createOrder"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func getOrdersService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.getOrders
        let url = Constants.serverUrl + "order/getOrders"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func forgotPasswordService<T: Mappable> (obj: T.Type, delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.forgotPassword
        let url = Constants.serverUrl + "index/forgetPassword"
        genericObjectService(url: url, obj: obj, params, serviceID: serviceID, delegate: delegate)
    }
    
    class func postStripePaymentService(delegate: ServiceDelegate, params: Parameters) {
        let serviceID = Service.postStripePayment
        let url = "https://foodsurfing-euro.herokuapp.com/create_charge"
        let method = HTTPMethod.post

        Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseString { response in
                
                switch response.result {
                case .success( _):
                    print(response.result.value)
                    print(response.response?.statusCode)
                    delegate.onSuccess(data: response, serviceID: serviceID)
                    break
                    
                case .failure( _):
                    delegate.onFailure(serviceID: serviceID)
                    break
                }
        }
    }
    
    
    //    ----------------------------------- GENERIC METHODS --------------------------------------------
    
    class func genericObjectGetService<T: Mappable>(url: String, obj: T.Type, serviceID: Service, delegate: ServiceDelegate) {
        Alamofire.request(url)
            .responseObject { (response: DataResponse<T>) in
                switch response.result {
                case .success( _):
                    delegate.onSuccess(data: response.result.value as Any, serviceID: serviceID)
                    break
                    
                case .failure( _):
                    delegate.onFailure(serviceID: serviceID)
                    break
                } //switch
        }
    }
    
    class func genericArrayGetService<T: Mappable>(url: String, obj: T.Type, serviceID: Service, delegate: ServiceDelegate) {
        
        Alamofire.request(url)
            .responseArray { (response: DataResponse<[T]>) in
                
                switch response.result {
                case .success( _):
                    delegate.onSuccess(data: response.result.value as Any, serviceID: serviceID)
                    break
                    
                case .failure( _):
                    delegate.onFailure(serviceID: serviceID)
                    break
                } //switch
        }
    }
    
    class func genericObjectService<T: Mappable>(url: String, obj: T.Type, _ params: Parameters, serviceID: Service, delegate: ServiceDelegate) {
        
        guard Helper.isInternetAvailable() else {
            Helper.showToast(message: "Bitte überprüfen Sie lhre Internetverbindung")
            delegate.onFailure(serviceID: serviceID)
            return
        }
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseObject { (response: DataResponse<T>) in
                switch response.result {
                case .success( _):
                    delegate.onSuccess(data: response.result.value as Any, serviceID: serviceID)
                    break
                    
                case .failure( _):
                    delegate.onFailure(serviceID: serviceID)
                    break
                } //switch
        }
    }
    
}
