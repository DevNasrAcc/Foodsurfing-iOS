//
//  SettingCell.swift
//  Foodsurfing
//
//  Created by developer on 22/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var txtQty: UITextField!
    var mealId: String?
    
    @IBAction func btnPlusAction(_ sender: Any) {
        let intValue = Int(txtQty.text ?? "0") ?? 0
        txtQty.text = "\(intValue+1)"
    }
    
    @IBAction func btnMinusAction(_ sender: Any) {
        let intValue = Int(txtQty.text ?? "0") ?? 0
        if intValue != 0 {
            txtQty.text = "\(intValue-1)"
        }
        else {
            txtQty.text = "\(intValue)"
        }
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        let vc = self.viewController() as! SettingsController
        Helper.addLoading(view: (vc.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "meal_id" : mealId ?? "",
            "quantity": txtQty.text ?? ""
        ]
        Services.updateMealQtyService(obj: GenericResp.self, delegate: vc, params: params)
    }
    
    
}
