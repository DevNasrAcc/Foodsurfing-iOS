//
//  LoginController.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import FacebookLogin
import FacebookCore
import FBSDKCoreKit

class LoginController: UIViewController, ServiceDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var parameters: Parameters = [:]
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        if (txtUsername.text ?? "").isEmpty || (txtPassword.text ?? "").isEmpty {
            Helper.showToast(message: "Bitte füllen Sie die E-mail- und Passwort-Fildern ein.")
            return
        }
        
        Helper.addLoading(view: self.view, isRemovable: false)
        let params: Parameters = [
            "email" : txtUsername.text ?? "",
            "password" : txtPassword.text ?? ""
        ]
        Services.loginService(obj: LoginResp.self, delegate: self, params: params)
    }
    
    @IBAction func btnFbAction(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ ReadPermission.publicProfile, ReadPermission.email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, let _, let accessToken):
                
                Helper.addLoading(view: self.view, isRemovable: false)
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"email, first_name, last_name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start { (response, result) in
                    switch result {
                    case .success(let value):
                        print(value.dictionaryValue)
                        let dict = value.dictionaryValue ?? [:]
                        let params: Parameters = [
                            "email" : dict["email"] ?? "",
                            "firstname" : dict["first_name"] ?? "",
                            "lastname" : dict["last_name"] ?? "",
                            "password"  : accessToken.userId ?? "",
                            "call_from" : "iphone",
                            "social_user" : "facebook",
                            "social_user_id" : accessToken.userId ?? ""
                        ]
                        self.parameters = params
                        self.loginFacebookUser(params: self.parameters)
                        
                    case .failed(let error):
                        Helper.dismissLoadingView(view: self.view)
                        print(error)
                    }
                }
            }
        }
    }
    
    func loginFacebookUser(params: Parameters) {
        print(params)
        Services.fbLoginService(obj: LoginResp, delegate: self, params: params)
    }
    
    @IBAction func btnSkipAction(_ sender: Any) {
        AppDelegate.isDemoMode = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationNavController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    //MARK: Delegates
    func onSuccess(data: Any, serviceID: Service) {
        if serviceID == .login || serviceID == .fbLogin || serviceID == .register {
            let loginResp = data as! LoginResp
            if (loginResp.error ?? "") == "OK" {
                Helper.dismissLoadingView(view: self.view)
                if loginResp.role ?? "" == "2" {
                    Helper.setKey(key: Constants.tokenKey, value: loginResp.token ?? "")
                    Helper.setKey(key: Constants.userIdKey, value: loginResp.user_id ?? "")
                    Helper.setKey(key: Constants.userRole, value: "rest")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "restNavController")
                    self.present(vc!, animated: true, completion: nil)
                }
                else if loginResp.role ?? "3" == "3" {
                    Helper.setKey(key: Constants.tokenKey, value: loginResp.token ?? "")
                    Helper.setKey(key: Constants.userIdKey, value: loginResp.user_id ?? "")
                    Helper.setKey(key: Constants.userRole, value: "cust")
                    AppDelegate.isDemoMode = false
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationNavController")
                    self.present(vc!, animated: true, completion: nil)
                }
            }
            else {
                if serviceID == .fbLogin && (loginResp.error ?? "") == "AUTHORIZATION_FAILED" {
                    Services.registerService(obj: LoginResp.self, delegate: self, params: self.parameters)
                }
                else {
                    Helper.dismissLoadingView(view: self.view)
                    Helper.showToast(message: "Wrong email or password")
                }
            }
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: self.view)
    }
    
}
