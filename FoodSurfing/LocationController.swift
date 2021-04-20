//
//  LocationController.swift
//  Foodsurfing
//
//  Created by developer on 27/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class LocationController: CustBaseController {
    
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtPostbox: UITextField!
    
    
    @IBAction func btnLocationAction(_ sender: Any) {
        if (txtLocation.text ?? "").isEmpty || (txtPostbox.text ?? "").isEmpty {
            Helper.showToast(message: "Stellen Sie sicher, dass Sie die Stadt korrekt eingegeben haben")
            return
        }
        LocationInfo.isCurrentLocation = false
        LocationInfo.placeName = (txtLocation.text ?? "")
        LocationInfo.pobox = (txtPostbox.text ?? "")
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    @IBAction func btnCurrentLocationAction(_ sender: Any) {
        LocationInfo.isCurrentLocation = true
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
}
