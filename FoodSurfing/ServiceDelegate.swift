//
//  ServiceDelegate.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import Alamofire

protocol ServiceDelegate {
    
    func onSuccess(data: Any, serviceID: Service)
    func onFailure(serviceID: Service)
    
}
