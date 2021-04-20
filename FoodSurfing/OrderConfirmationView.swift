//
//  OrderConfirmationView.swift
//  Foodsurfing
//
//  Created by developer on 20/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class OrderConfirmationView: UIView {
    
    @IBOutlet weak var lblOrderNumber: UILabel!
    var delegate: OrderConfirmationDelegate?
    
    class func instanceFromNib() -> UIView {
        let instance = UINib(nibName: "OrderConfirmationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OrderConfirmationView
        return instance
    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        delegate?.orderConfirmed()
        self.superview?.removeFromSuperview()
    }
    
}
