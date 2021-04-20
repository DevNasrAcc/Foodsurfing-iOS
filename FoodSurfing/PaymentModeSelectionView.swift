//
//  PaymentModeSelectionView.swift
//  Foodsurfing
//
//  Created by developer on 18/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class PaymentModeSelectionView: UIView {
    
    @IBOutlet weak var btnVisa: UIButton!
    @IBOutlet weak var btnPaypal: UIButton!
    var paymentModeSelected: Int = 0        //0- none, 1- visa, 2- paypal
    var delegate: PaymentModeSelectionDelegate?
    
    class func instanceFromNib() -> UIView {
        let instance = UINib(nibName: "PaymentModeSelectionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PaymentModeSelectionView
        return instance
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.superview?.removeFromSuperview()
    }
    
    @IBAction func btnSectionAction(_ sender: Any) {
        if self.paymentModeSelected == 0 {
            return
        }
        delegate?.onPaymentModeSelection(selectedMethodIndex: self.paymentModeSelected)
        self.superview?.removeFromSuperview()
    }
    
    @IBAction func btnVisaAction(_ sender: Any) {
        self.paymentModeSelected = 1
        btnVisa.setImage(UIImage(named: "visa-checked"), for: .normal)
        btnPaypal.setImage(UIImage(named: "paypal-unchecked"), for: .normal)
    }
    
    @IBAction func btnPaypalAction(_ sender: Any) {
        self.paymentModeSelected = 2
        btnVisa.setImage(UIImage(named: "visa-unchecked"), for: .normal)
        btnPaypal.setImage(UIImage(named: "paypal-checked"), for: .normal)
    }
    
}
