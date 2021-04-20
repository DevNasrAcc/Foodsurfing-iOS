//
//  RestInfoWindow.swift
//  Foodsurfing
//
//  Created by developer on 26/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class RestInfoWindow: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    var delegate: RestInfoWindowDelegate?
    var restaurant: Restaurant?
    
    class func instanceFromNib(rest: Restaurant) -> UIView {
        let instance = UINib(nibName: "RestInfoWindow", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RestInfoWindow
        instance.lblTitle.text = rest.name
        instance.lblAddress.text = rest.address
        instance.lblContact.text = rest.contact_person
        instance.lblPhone.text = rest.phone
        instance.restaurant = rest
        return instance
    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        guard let rest = restaurant else {
            return
        }
        self.superview?.removeFromSuperview()
        delegate?.infoWindowClosed(rest: rest)
    }
    
}
