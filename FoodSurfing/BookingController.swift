//
//  BookingController.swift
//  Foodsurfing
//
//  Created by developer on 24/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class BookingController: CustBaseController, ServiceDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblNoEntry: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var orders: [BookingResp.TodayOrder?] = []
    
    override func viewDidLoad() {
        super.isRest = true
        super.selectedScreen = .bookings
        super.viewDidLoad()
        
        //calling data
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? ""
        ]
        Services.todayBookingService(obj: BookingResp.self, delegate: self, params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.tableFooterView = UIView()
    }
    
    func switchArrow(cell: BookingCell, isExp: Bool) {
        if isExp {
            cell.imgPlus.image = UIImage(named: "minus-icon")
        }
        else {
            cell.imgPlus.image = UIImage(named: "plus-icon-pink")
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
            lblNoEntry.isHidden = true
        }
        else {
            lblNoEntry.isHidden = false
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell") as! BookingCell
            cell.lblTitle.text = d.customer_name ?? ""
            cell.lblPrice.text = "\(d.total_price ?? "") \(d.currency ?? "")"
            switchArrow(cell: cell, isExp: d.isExpanded)
            cell.orderId = d.id
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
        if serviceID == .markFav {
            return
        }
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        if serviceID == .todayBooking {
            let bookingResp = data as! BookingResp
            if (bookingResp.error ?? "") == "OK" {
                orders = bookingResp.orders ?? []
                tableview.reloadData()
            }
        }
        else if serviceID == .cancelOrder {
            let resp = data as! GenericResp
            if (resp.error ?? "") == "OK" {
                orders = []
                Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
                let params: Parameters = [
                    "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? ""
                ]
                Services.todayBookingService(obj: BookingResp.self, delegate: self, params: params)
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
