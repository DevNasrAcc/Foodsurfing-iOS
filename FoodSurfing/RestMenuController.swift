//
//  RestMenuController.swift
//  Foodsurfing
//
//  Created by developer on 21/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class RestMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    var menuDelegate: MenuDelegate?
    var selectedScreen: MenuItem = MenuItem.bookings
    
    
    func getScreenId(forIndex: Int) -> MenuItem {
        switch forIndex {
        case 0:
            return MenuItem.bookings
            
        case 1:
            return MenuItem.statistics
            
        case 2:
            return MenuItem.profile
            
        case 3:
            return MenuItem.settings
            
        case 4:
            return MenuItem.logout
            
        default:
            return MenuItem.bookings
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 { return }
        var cell = tableView.cellForRow(at: indexPath)
        cell = (indexPath.row < 5) ? cell as! MenuCell : cell as! MenuLinkCell
        
        switch indexPath.row {
        case 0:
            selectedScreen = .bookings
            break
            
        case 1:
            selectedScreen = .statistics
            break
            
        case 2:
            selectedScreen = .profile
            break
            
        case 3:
            selectedScreen = .settings
            break
            
        case 4:
            selectedScreen = .logout
            break
        
        case 6:
            Helper.shareByWhatsapp(msg: "Let me recommend you Foodsurfing application", vc: self)
            break
            
        case 7:
            UIApplication.shared.open(URL(string: "https://www.facebook.com/Foodsurfers/")!, options: [:], completionHandler: nil)
            break
            
        case 8:
            UIApplication.shared.open(URL(string: "http://foodsurfing.eu/contact")!, options: [:], completionHandler: nil)
            break
            
        case 9:
            UIApplication.shared.open(URL(string: "http://www.foodsurfing.eu/")!, options: [:], completionHandler: nil)
            break
            
        default:
            break
        }
        
        if cell is MenuCell {
            cell?.isSelected = true
            menuDelegate?.onMenuItemSelection(screenId: selectedScreen)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is MenuCell {
            cell?.isSelected = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "Heutige Bestellungen"
            cell.imgIcon.image = UIImage(named: "booking-icon-default")
            cell.imageName = "booking-icon-default"
            break
            
        case 1:
            cell.lblTitle.text = "Statistiken"
            cell.imgIcon.image = UIImage(named: "stat-icon-default")
            cell.imageName = "stat-icon-default"
            break
            
        case 2:
            cell.lblTitle.text = "Benutzerprofil"
            cell.imgIcon.image = UIImage(named: "profile-icon-default")
            cell.imageName = "profile-icon-default"
            break
            
        case 3:
            cell.lblTitle.text = "Settings"
            cell.imgIcon.image = UIImage(named: "settings-icon-default")
            cell.imageName = "settings-icon-default"
            break
            
        case 4:
            cell.lblTitle.text = "Abmelden"
            cell.imgIcon.image = UIImage(named: "logout-icon-default")
            cell.imageName = "logout-icon-default"
            break
            
        case 5:
            return tableView.dequeueReusableCell(withIdentifier: "menuDividerCell")!
            
        case 6:
            let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
            c.lblTitle.text = "Freunde einladen"
            return c
            
        case 7:
            let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
            c.lblTitle.text = "Folge uns auf Facebook"
            return c
            
        case 8:
            let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
            c.lblTitle.text = "Kontakt"
            return c
            
        case 9:
            let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
            c.lblTitle.text = "Webseite"
            return c
            
            
        default:
            break
        }
        
        if getScreenId(forIndex: indexPath.row) == self.selectedScreen {
            cell.isSelected = true
        }
        
        return cell
    }
    
}
