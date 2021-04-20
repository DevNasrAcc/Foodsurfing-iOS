//
//  BucketCell.swift
//  Foodsurfing
//
//  Created by developer on 12/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class BucketCell: UITableViewCell {
    
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var imgFav: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var txtQty: UITextField!
    var mealIndex: Int = -1
    var delegate: BucketDelegate?
    
    @IBAction func btnMinusAction(_ sender: Any) {
        let intValue = Int(txtQty.text ?? "0") ?? 0
        if intValue != 0 {
            txtQty.text = "\(intValue-1)"
        }
        else {
            txtQty.text = "\(intValue)"
        }
        AppDelegate.bucketMeals[mealIndex].qtySelected = txtQty.text
        delegate?.dataChanged()
    }
    
    @IBAction func btnPlusAction(_ sender: Any) {
        let intValue = Int(txtQty.text ?? "0") ?? 0
        if intValue == Int(lblQty.text ?? "100") ?? 100 {
            Helper.showToast(message: "No more than \(intValue) items are available")
        }
        else {
            txtQty.text = "\(intValue+1)"
        }
        AppDelegate.bucketMeals[mealIndex].qtySelected = txtQty.text
        delegate?.dataChanged()
    }
    
    @IBAction func btnRemoveAction(_ sender: Any) {
        AppDelegate.bucketMeals.remove(at: mealIndex)
        delegate?.dataChanged()
    }
    
}
