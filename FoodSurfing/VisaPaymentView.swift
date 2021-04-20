//
//  VisaPaymentView.swift
//  Foodsurfing
//
//  Created by developer on 18/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class VisaPaymentView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtExpiry: UITextField!
    @IBOutlet weak var txtSecretPin: UITextField!
    var delegate: VisaPaymentDelegate?
    
    class func instanceFromNib() -> UIView {
        let instance = UINib(nibName: "VisaPaymentView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VisaPaymentView
        instance.txtNumber.delegate = instance
        instance.txtExpiry.delegate = instance
        instance.txtSecretPin.delegate = instance
        return instance
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        if (txtName.text ?? "").isEmpty || (txtNumber.text ?? "").isEmpty || (txtExpiry.text ?? "").isEmpty || (txtSecretPin.text ?? "").isEmpty {
            Helper.showToast(message: "Please fill all fields")
            return
        }
        
        let componentsExpiry = txtExpiry.text!.components(separatedBy: "/")
        if componentsExpiry.count < 2 {
            Helper.showToast(message: "Please enter the valid expiry")
            return
        }
        
        let cardParams = STPCardParams()
        cardParams.number   = txtNumber.text!.trimmingCharacters(in: .whitespaces)
        cardParams.expMonth = UInt(componentsExpiry[0])!
        cardParams.expYear = UInt("20\(componentsExpiry[1])")!
        cardParams.cvc = txtSecretPin.text!
        
        delegate?.onVisaInfoProvided(cardParams: cardParams)
        self.superview?.removeFromSuperview()
    }
    
    @IBAction func btnDismissAction(_ sender: Any) {
        self.superview?.removeFromSuperview()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Formating credit card number
        if textField == self.txtNumber {
            if range.location == 19 {
                return false
            }
            
            if range.length == 1 {
                print(textField.text ?? "")
                if (range.location == 5 || range.location == 10 || range.location == 15) {
                    let text = textField.text ?? ""
                    textField.text = text.substring(to: text.index(before: text.endIndex))
                }
                return true
            }
            
            if (range.location == 4 || range.location == 9 || range.location == 14) {
                textField.text = String(format: "%@ ", textField.text ?? "")
            }
            return true
        }
        
        // Formatting Expiry
        if textField == self.txtExpiry {
            if range.location == 5 {
                return false
            }
            
            if range.length == 1 {
                if range.location == 3 {
                    let text = textField.text ?? ""
                    textField.text = text.substring(to: text.index(before: text.endIndex))
                }
                return true
            }
            
            if range.location == 2 {
                textField.text = String(format: "%@/", textField.text ?? "")
            }
            return true
        }
        
        // Formatting CVC
        if textField == self.txtSecretPin {
            if range.location >= 3 {
                return false
            }
        }
        
        return true
    }
    
}
