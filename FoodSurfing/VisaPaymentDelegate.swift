//
//  VisaPaymentDelegate.swift
//  Foodsurfing
//
//  Created by developer on 18/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import Stripe

protocol VisaPaymentDelegate {
    func onVisaInfoProvided(cardParams: STPCardParams)
}
