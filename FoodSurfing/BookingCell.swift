//
//  BookingCell.swift
//  Foodsurfing
//
//  Created by developer on 24/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class BookingCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    var orderId: String?
    
    @IBAction func btnDltAction(_ sender: Any) {
        let vc = self.viewController() as! BookingController
        Helper.addLoading(view: (vc.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "order_id" : orderId ?? "",
        ]
        Services.cancelOrderService(obj: GenericResp.self, delegate: vc, params: params)
    }
    
}
