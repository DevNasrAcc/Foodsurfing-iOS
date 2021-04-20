//
//  RestaurantController.swift
//  Foodsurfing
//
//  Created by developer on 28/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class RestaurantController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    var selectedRest: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.tableFooterView = UIView()
        self.tableview.reloadData()
        
        //Register as Notification receiver
        NotificationCenter.default.addObserver(self, selector: #selector(actOnDataSetChanged), name: NSNotification.Name(rawValue: Constants.notifTagRestDataChange), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? "") == "toRestDetail" {
            let dest = segue.destination as! RestDetailController
            dest.restaurant = self.selectedRest
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func actOnDataSetChanged() {
        self.tableview.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lblNotFound.isHidden = HomeController.restaurants.count > 0
        return HomeController.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRest = HomeController.restaurants[indexPath.row]
        performSegue(withIdentifier: "toRestDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantCell
        let rest = HomeController.restaurants[indexPath.row]
        let url = URL(string: rest.img ?? "")
        cell.imgBg.kf.setImage(with: url)
        let url2 = URL(string: rest.logo ?? "")
        cell.imgLogo.kf.setImage(with: url2)
        cell.lblTitle.text = rest.name ?? ""
        cell.lblTiming.text = "Abholzeit: \(rest.pickup_time ?? "")"
        cell.lblDistance.text = String(format: "%.1f k.m", Float(rest.distance ?? "0.0")!)
        cell.dotView.backgroundColor = (rest.availability ?? "false") == "true" ? Constants.primaryColor : Constants.dotGreyColor
        return cell
    }
}
