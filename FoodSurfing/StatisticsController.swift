//
//  StatisticsController.swift
//  Foodsurfing
//
//  Created by developer on 21/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class StatisticsController: CustBaseController, ServiceDelegate, UITableViewDelegate, UITableViewDataSource, DateSelectionDelegate {
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var orders: [StatisticsResp.StatisticsOrder?] = []
    var isStartDateOpened = true
    
    
    override func viewDidLoad() {
        super.isRest = true
        super.selectedScreen = .statistics
        super.viewDidLoad()

        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? ""
        ]
        Services.statisticsService(obj: StatisticsResp.self, delegate: self, params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.tableFooterView = UIView()
    }
    
    @IBAction func btnStartDateAction(_ sender: Any) {
        self.isStartDateOpened = true
        Helper.openCalendar(vc: self)
    }
    
    @IBAction func btnEndDateAction(_ sender: Any) {
        self.isStartDateOpened = false
        Helper.openCalendar(vc: self)
    }
    
    @IBAction func btnSearchAction(_ sender: Any) {
        if (lblStartDate.text ?? "").contains("-") && (lblEndDate.text ?? "").contains("-") {
            if (Helper.stringToDate(str: lblStartDate.text ?? "") ?? Date()).compare(Helper.stringToDate(str: lblEndDate.text ?? "") ?? Date()) == ComparisonResult.orderedDescending {
                Helper.showToast(message: "End date must be greater than start date")
                return
            }
            
            Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
            let params: Parameters = [
                "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? "",
                "start_date" : lblStartDate.text ?? "",
                "end_date" : lblEndDate.text ?? ""
            ]
            Services.filteredStatisticsService(obj: StatisticsResp.self, delegate: self, params: params)
            self.orders = []
        }
        else {
            Helper.showToast(message: "Bitte ein Start- und Enddatum wählen")
        }
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
        var selectedCell: StatisticsResp.StatisticsOrder?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = orders[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
    
    
    //MARK: Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.lblTitle.text = d.created_at
            cell.lblCurrency.text = "\(d.total_price ?? "") \(d.currency ?? "")"
            switchArrow(cell: cell, isExp: d.isExpanded)
            return cell
        }
        else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "statDetailCell") as! StatDetailCell
            let parentCellIndex = self.getParentCellIndex(expansionIndex: indexPath.row)
            let childIndex = indexPath.row - parentCellIndex - 1
            if let order = orders[parentCellIndex] {
                if let meals = order.meals {
                    let meal = meals[childIndex]
                    cell.lblTitleName.text = order.customer_name
                    cell.lblEmail.text = order.customer_email
                    cell.lblTitleMeal.text = meal.meal_title
                    cell.lblQty.text = meal.quantity
                    cell.lblCost.text = "\(meal.price ?? "")\(order.currency ?? "")"
                }
            }
            return cell
        }
    }
    
    func onSuccess(data: Any, serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        if serviceID == Service.statistics || serviceID == Service.filteredStatistics {
            let statResp = data as! StatisticsResp
            if (statResp.error ?? "") == "OK" {
                self.orders = statResp.orders ?? []
                tableview.reloadData()
            }
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
    }
    
    func onDateSelected(selectedDate: Date) {
        if self.isStartDateOpened {
            lblStartDate.text = Helper.DateToString(date: selectedDate)
        }
        else {
            lblEndDate.text = Helper.DateToString(date: selectedDate)
        }
    }
    
}
