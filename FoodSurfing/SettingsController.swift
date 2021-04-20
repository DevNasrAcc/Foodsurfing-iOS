//
//  SettingsController.swift
//  Foodsurfing
//
//  Created by developer on 22/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SettingsController: CustBaseController, ServiceDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var imgRestLogo: UIImageView!
    var restaurantInfo: SettingsResp.RestaurantInfo?
    var meals: [SettingsResp.RestaurantInfo.RestaurantMeal] = []
    
    override func viewDidLoad() {
        super.selectedScreen = .settings
        super.isRest = true
        super.viewDidLoad()
        
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? ""
        ]
        Services.settingsService(obj: SettingsResp.self, delegate: self, params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.tableFooterView = UIView()
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        txtStartTime.resignFirstResponder()
        txtEndTime.resignFirstResponder()
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "restaurant_id" : restaurantInfo?.id ?? "",
            "start_pickup_time" : txtStartTime.text ?? "",
            "end_pickup_time" : txtEndTime.text ?? ""
        ]
        Services.updatePickupTimeService(obj: GenericResp.self, delegate: self, params: params)
    }
    
    func updateRestInfo() {
        if let restInfo = self.restaurantInfo {
            lblTitle.text = restInfo.name
            txtDesc.text = restInfo.description
            txtStartTime.text = restInfo.startTime
            txtEndTime.text = restInfo.endTime
            let url = URL(string: restInfo.logo ?? "")
            imgRestLogo.kf.setImage(with: url)
        }
    }
    
    //MARK: Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtStartTime || textField == txtEndTime {
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
                textField.text = String(format: "%@:", textField.text ?? "")
            }
        }
        
        return true
    }
    
    func onSuccess(data: Any, serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        if serviceID == .settings {
            let settingResp = data as! SettingsResp
            if (settingResp.error ?? "") == "OK" {
                self.restaurantInfo = settingResp.restaurant
                self.meals = settingResp.restaurant?.restaurant_meals ?? []
                updateRestInfo()
                self.tableview.reloadData()
            }
        }
        else if serviceID == .updatePickupTime {
            let resp = data as! GenericResp
            if (resp.error ?? "") == "OK" {
                Helper.showToast(message: "Abholzeit aktualisiert")
            }
        }
        else if serviceID == .updateMealQty {
            let resp = data as! GenericResp
            if (resp.error ?? "") == "OK" {
                Helper.showToast(message: "Einstellungen werden gespeichert")
            }
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        let meal = meals[indexPath.row]
        cell.lblTitle.text = meal.title
        cell.txtDesc.text = meal.description ?? ""
        cell.lblPrice.text = "\(meal.price ?? "") \(restaurantInfo?.currency ?? "")"
        cell.txtQty.text = meal.quantity
        let url = URL(string: meal.image ?? "")
        cell.imgLogo.kf.setImage(with: url)
        cell.mealId = meal.id
        return cell
    }
    
}
