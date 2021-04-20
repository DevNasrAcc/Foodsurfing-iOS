//
//  RestDetailViewController.swift
//  Foodsurfing
//
//  Created by developer on 13/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RestDetailController: UIViewController, ServiceDelegate {
    
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var imgHeaderLogo: UIImageView!
    @IBOutlet weak var lblHeaderRestName: UILabel!
    @IBOutlet weak var imgMealImage: UIImageView!
    @IBOutlet weak var lblMealTitle: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var descView: UIView!
    
    var restaurant: Restaurant?
    var meal: Meal?
    var isFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding top right cart button
        let cartIcon = UIImage(named: "cart-icon-white")
        let cartBarButton = UIBarButtonItem(image: cartIcon, style: .done, target: self, action: #selector(cartButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = cartBarButton
        
//        cartBarButton.badgeBGColor = UIColor.white
//        cartBarButton.badgeTextColor = Helper.hexStringToUIColor(hex: "b40047")
        
        //Inflate data
        if let rest = self.restaurant {
            let url = URL(string: rest.img ?? "")
            self.imgHeader.kf.setImage(with: url)
            let url2 = URL(string: rest.logo ?? "")
            self.imgHeaderLogo.kf.setImage(with: url2)
            self.lblHeaderRestName.text = rest.name ?? ""
            self.navigationItem.title = rest.name ?? ""
        }
        else {
            let url = URL(string: meal?.meal_image ?? "")
            self.imgHeader.kf.setImage(with: url)
        }
        
        guard let rest = restaurant else {
            inflateMealData()
            return
        }
        
        //calling data
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? "0",
            "restaurant_id" : rest.id ?? ""
        ]
        Services.getRestaurnatMealsService(obj: RestMealsResp.self, delegate: self, params: params)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Helper.updateBadge(forView: self.navigationItem.rightBarButtonItem, count: AppDelegate.bucketMeals.count)
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
    
    @IBAction func btnPlusAction(_ sender: Any) {
        let intValue = Int(txtQty.text ?? "0") ?? 0
        if intValue == Int(lblQty.text ?? "100") ?? 100 {
            Helper.showToast(message: "No more than \(intValue) items are available")
        }
        else {
            txtQty.text = "\(intValue+1)"
        }
    }
    
    @IBAction func btnOrderAction(_ sender: Any) {
        //If qty is zero or none
        if (txtQty.text ?? "0") == "0" || (txtQty.text ?? "0").isEmpty {
            Helper.showToast(message: "Vergewissern Sie sich, dass Sie mindestens einen Artikel")
            return
        }
        
        if (restaurant?.availability ?? "true") != "true" {
            Helper.showToast(message: "Not Available")
            return
        }
        
        if let m = self.meal {
            for (i, item) in AppDelegate.bucketMeals.enumerated() {
                if item.id == m.id {
                    AppDelegate.bucketMeals.remove(at: i)
                    break
                }
            }
            m.qtySelected = txtQty.text ?? "0"
            AppDelegate.bucketMeals.append(m)
            Helper.updateBadge(forView: self.navigationItem.rightBarButtonItem, count: AppDelegate.bucketMeals.count)
            Helper.showToast(message: "Artikel dem Warenkorb hinzugefügt!")
        }
    }
    
    @IBAction func btnFavAction(_ sender: Any) {
        if AppDelegate.isDemoMode {
            Helper.showToast(message: "Login, um diese Funktion zu nutzen")
            return
        }
        
        self.isFavorite = !self.isFavorite
        updateFav()
        let params: Parameters = [
            "meal_id" : meal?.id ?? "",
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? "",
            "status" : self.isFavorite ? "active" : "remove"
        ]
        Services.markFavouriteService(obj: GenericResp.self, delegate: self, params: params)
    }
    
    func cartButtonPressed(_ sender: UIBarButtonItem ) {
        if AppDelegate.bucketMeals.count > 0 {
            performSegue(withIdentifier: "toCart", sender: nil)
        }
    }
    
    func updateFav() {
        if self.isFavorite {
            self.btnFav.setImage(UIImage(named: "fav-icon-highlight"), for: .normal)
        }
        else {
            self.btnFav.setImage(UIImage(named: "unfav-icon"), for: .normal)
        }
    }
    
    func inflateMealData() {
        guard let m = self.meal else {
            return
        }
        
        lblMealTitle.text = m.title ?? ""
        lblCost.text = "\(m.price ?? "") \(m.currency ?? "")"
        lblQty.text = m.quantity ?? ""
        let url = URL(string: m.img ?? m.meal_image ?? "")
        imgMealImage.kf.setImage(with: url)
        txtDescription.text = m.description ?? ""
        lblPickupTime.text = m.pickup_time ?? ""
        lblHeaderRestName.text = restaurant?.name ?? m.restaurant_name ?? ""
        self.navigationItem.title = restaurant?.name ?? m.restaurant_name ?? ""
        self.isFavorite = m.is_favorite ?? false
        updateFav()
        self.descView.isHidden = false
    }
    
    //MARK: Delegates
    func onSuccess(data: Any, serviceID: Service) {
        if serviceID == .markFav {
            return
        }
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        if serviceID == .restMeals {
            let resp = data as! RestMealsResp
            if (resp.error ?? "") == "OK" {
                self.meal = resp.meals?.first
                inflateMealData()
            }
        }
    }
    
    func onFailure(serviceID: Service) {
        if serviceID == .markFav {
            return
        }
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
    }
    
}
