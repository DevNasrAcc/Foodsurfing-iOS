//
//  FavoriteController.swift
//  Foodsurfing
//
//  Created by developer on 28/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class FavoriteController: CustBaseController, UITableViewDelegate, UITableViewDataSource, ServiceDelegate, FavoriteDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    
    var meals: [Meal] = []
    var selectedMeal: Meal?
    
    override func viewDidLoad() {
        super.selectedScreen = .favorites
        super.viewDidLoad()
        
        //calling data
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? ""
        ]
        Services.getFavouriteMealsService(obj: FavoritesResp.self, delegate: self, params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? "") == "toRestDetail" {
            let dest = segue.destination as! RestDetailController
            dest.meal = selectedMeal
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lblNotFound.isHidden = meals.count > 0
        return self.meals.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMeal = meals[indexPath.row]
        performSegue(withIdentifier: "toRestDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! FavoriteCell
        let meal = meals[indexPath.row]
        cell.lblTitle.text = meal.title ?? ""
        cell.txtDesc.text = meal.description ?? ""
        cell.lblRestName.text = meal.restaurant_name ?? ""
        cell.lblCost.text = "\(meal.price ?? "") \(meal.currency ?? "")"
        let url = URL(string: meal.meal_image ?? "")
        cell.imgMeal.kf.setImage(with: url)
        cell.delegate = self
        cell.index = indexPath.row
        return cell
    }
    
    func onSuccess(data: Any, serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        if serviceID == .favMeals {
            let resp = data as! FavoritesResp
            if (resp.error ?? "") == "OK" {
                self.meals = resp.meals ?? []
                tableview.reloadData()
            }
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
    }
    
    func markUnfovorite(atIndex: Int) {
        let params: Parameters = [
            "meal_id"   : meals[atIndex].meal_id ?? "",
            "user_id"   : Helper.getValue(forKey: Constants.userIdKey) ?? "",
            "status"    : "remove"
        ]
        Services.markFavouriteService(obj: GenericResp.self, delegate: self, params: params)
        print(params)
        meals.remove(at: atIndex)
        tableview.reloadData()
    }
    
}
