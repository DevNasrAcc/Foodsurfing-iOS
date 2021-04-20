//
//  OrdersController.swift
//  Foodsurfing
//
//  Created by developer on 12/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class OrdersController: CustBaseController, UITableViewDelegate, UITableViewDataSource, ServiceDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblNoOrdersFound: UILabel!
    var orders: [BookingResp.TodayOrder?] = []
    
    override func viewDidLoad() {
        super.selectedScreen = .orders
        super.viewDidLoad()
        
        //calling data
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? ""
        ]
        Services.getOrdersService(obj: BookingResp.self, delegate: self, params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.tableFooterView = UIView()
    }
    
    func switchArrow(cell: StatCell, isExp: Bool) {
        if isExp {
            cell.imgPlusIcon.image = UIImage(named: "minus-icon")
        }
        else {
            cell.imgPlusIcon.image = UIImage(named: "plus-icon-pink")
        }
    }
    
    func fillOrRemoveData(atIndex: Int) {
        if let d = orders[atIndex] {
            if d.isExpanded {
                if let arr = d.meals {
                    for _ in arr {
                        self.orders.insert(nil, at: atIndex+1)
                    }
                }
            }
            else {
                while (atIndex < self.orders.count-1 && self.orders[atIndex+1] == nil) {
                    self.orders.remove(at: atIndex+1)
                }
            }
        }
        self.tableview.reloadData()
    }
    
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        var selectedCell: BookingResp.TodayOrder?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = orders[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
    
    //MARK: Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orders.count > 0 {
            lblNoOrdersFound.isHidden = true
        }
        else {
            lblNoOrdersFound.isHidden = false
        }
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let d = orders[indexPath.row] {
            d.isExpanded = !d.isExpanded
            fillOrRemoveData(atIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let d = orders[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statCell") as! StatCell
            cell.lblTitle.text = "# Ord-\(d.id ?? "")"
            cell.lblCurrency.text = "\(d.total_price ?? "") \(d.currency ?? "")"
            switchArrow(cell: cell, isExp: d.isExpanded)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookingDetailCell") as! BookingDetailCell
            let parentCellIndex = self.getParentCellIndex(expansionIndex: indexPath.row)
            let childIndex = indexPath.row - parentCellIndex - 1
            if let order = orders[parentCellIndex] {
                if let meals = order.meals {
                    let meal = meals[childIndex]
                    cell.lblTitleRestaurant.text = meal.restaurant_name
                    cell.lblAddress.text = meal.restaurant_address
                    cell.lblTime.text = "\(Helper.customDateFormatter(dateString: meal.restaurant_opening_time ?? "")) to \(Helper.customDateFormatter(dateString: meal.restaurant_closing_time ?? ""))"
                    cell.lblTitleMeal.text = meal.meal_title
                    cell.lblQty.text = meal.quantity
                    cell.lblDateTime.text = order.pickup_time
                    cell.lblCost.text = "\(meal.price ?? "")\(order.currency ?? "")"
                }
            }
            return cell
        }
    }
    
    
    func onSuccess(data: Any, serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        if serviceID == .getOrders {
            let resp = data as! BookingResp
            if (resp.error ?? "") == "OK" {
                self.orders = resp.orders ?? []
                tableview.reloadData()
            }
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
    }
    
}
