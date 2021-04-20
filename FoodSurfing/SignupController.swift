//
//  SignupController.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignupController: UIViewController, ServiceDelegate {
    
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var switchTermsConditions: UISwitch!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordAgain: UITextField!
    
    
    @IBAction func btnTermsAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://www.foodsurfing.eu/agb")!)
    }
    
    @IBAction func btnSignupAction(_ sender: Any) {
        if (txtFirstname.text ?? "").isEmpty ||
            (txtLastname.text ?? "").isEmpty ||
            (txtEmail.text ?? "").isEmpty ||
            (txtPassword.text ?? "").isEmpty ||
            !switchTermsConditions.isOn
        {
            Helper.showToast(message: "Es gelten die Allgemeinen Geschäftsbedingungen Bitte lesen Sie die AGB und Klicken Sie nachfolgend auf den Button zur Zustimmung. Beachten Sie bitte auch die Datenschutzhinweise.")
            return
        }
        
        if (txtPassword.text ?? "") != (txtPasswordAgain.text ?? "") {
            Helper.showToast(message: "Password confirm password again")
            return
        }
        
        Helper.addLoading(view: self.view, isRemovable: false)
        let params: Parameters = [
            "email" : txtEmail.text ?? "",
            "password" : txtPassword.text ?? "",
            "firstname": txtFirstname.text ?? "",
            "lastname": txtLastname.text ?? "",
            "call_from": "iphone"
        ]
        Services.registerService(obj: LoginResp.self, delegate: self, params: params)
    }
    
    @IBAction func btnLoginScreenAction(_ sender: Any) {
        
    }
    
    
    //MARK: Delegates
    func onSuccess(data: Any, serviceID: Service) {
        Helper.dismissLoadingView(view: self.view)
        let loginResp = data as! LoginResp
        if (loginResp.error ?? "") == "OK" {
            Helper.setKey(key: Constants.tokenKey, value: loginResp.token ?? "")
            Helper.setKey(key: Constants.userIdKey, value: loginResp.user_id ?? "")
            Helper.setKey(key: Constants.userRole, value: "cust")
            AppDelegate.isDemoMode = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationNavController")
            self.present(vc!, animated: true, completion: nil)
        }
        else {
            Helper.showToast(message: "Wrong email or password, Please try again")
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: self.view)
    }
    
}
