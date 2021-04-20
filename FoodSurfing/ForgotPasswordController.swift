//
//  ForgotPasswordController.swift
//  Foodsurfing
//
//  Created by developer on 06/11/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ForgotPasswordController: UIViewController, ServiceDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBAction func btnRegisterScreenAction(_ sender: Any) {
        performSegue(withIdentifier: "forgotToRegister", sender: nil)
    }
    
    @IBAction func btnSigninScreenAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        guard !(txtEmail.text ?? "").isEmpty else {
            Helper.showToast(message: "Stellen Sie sicher, dass Sie alle Felder ausgefüllt haben")
            return
        }
        
        Helper.addLoading(view: self.view, isRemovable: false)
        let params: Parameters = [
            "email" : txtEmail.text ?? ""
        ]
        Services.forgotPasswordService(obj: GenericResp.self, delegate: self, params: params)
    }
    
    //MARK: Delegates
    func onSuccess(data: Any, serviceID: Service) {
        Helper.dismissLoadingView(view: self.view)
        let resp = data as! GenericResp
        if (resp.error ?? "") == "OK" {
            Helper.showToast(message: "The new password has been sent to the given email address. Please login with new credentials")
            dismiss(animated: true, completion: nil)
        }
        else {
            Helper.showToast(message: "Bitte geben Sie die korrekte E-Mail Adresse ein")
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: self.view)
    }
    
}
