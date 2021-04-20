//
//  CustMenuController.swift
//  Foodsurfing
//
//  Created by developer on 27/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class CustMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    var menuDelegate: MenuDelegate?
    var selectedScreen: MenuItem = MenuItem.home
    var isLoggedIn: Bool = true
    
    func getScreenId(forIndex: Int) -> MenuItem {
        switch forIndex {
        case 0:
            return MenuItem.home
            
        case 1:
            return MenuItem.orders
            
        case 2:
            return MenuItem.favorites
            
        case 3:
            return !AppDelegate.isDemoMode ? MenuItem.profile : MenuItem.howWorks
            
        case 4:
            return MenuItem.howWorks
            
        case 5:
            return MenuItem.logout
            
        default:
            return MenuItem.home
        }
    }
    
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !AppDelegate.isDemoMode ? 11 : 9
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = tableView.cellForRow(at: indexPath)
        
        let dividerIndex = AppDelegate.isDemoMode ? 4 : 6
        if indexPath.row == dividerIndex { return }
        cell = (indexPath.row < dividerIndex) ? cell as! MenuCell : cell as! MenuLinkCell
        
        switch indexPath.row {
        case 0:
            selectedScreen = .home
            break
            
        case 1:
            selectedScreen = .orders
            break
            
        case 2:
            selectedScreen = .favorites
            break
            
        case 3:
            if !AppDelegate.isDemoMode {
                selectedScreen = .profile
            }
            else {
                menuDelegate?.onMenuItemSelection(screenId: .howWorks)
                return
            }
            break
            
        case 4:
            menuDelegate?.onMenuItemSelection(screenId: .howWorks)
            return
            
        case 5:
            if !AppDelegate.isDemoMode {
                selectedScreen = .logout
            }
            else {
                Helper.shareByWhatsapp(msg: "Let me recommend you Foodsurfing application", vc: self)
            }
            break
            
        case 6:
            UIApplication.shared.open(URL(string: "https://www.facebook.com/Foodsurfers/")!, options: [:], completionHandler: nil)
            break
            
        case 7:
            if AppDelegate.isDemoMode {
                UIApplication.shared.open(URL(string: "http://foodsurfing.eu/contact")!, options: [:], completionHandler: nil)
            }
            else {
                Helper.shareByWhatsapp(msg: "Let me recommend you Foodsurfing application", vc: self)
            }
            break
            
        case 8:
            if AppDelegate.isDemoMode {
                UIApplication.shared.open(URL(string: "http://www.foodsurfing.eu/")!, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.open(URL(string: "https://www.facebook.com/Foodsurfers/")!, options: [:], completionHandler: nil)
            }
            break
            
        case 9:
            UIApplication.shared.open(URL(string: "http://foodsurfing.eu/contact")!, options: [:], completionHandler: nil)
            break
            
        case 10:
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
            cell.lblTitle.text = "Home"
            cell.imgIcon.image = UIImage(named: "home-icon-default")
            cell.imageName = "home-icon-default"
            break
            
        case 1:
            cell.lblTitle.text = "Meine Bestellungen"
            cell.imgIcon.image = UIImage(named: "order-icon-default")
            cell.imageName = "order-icon-default"
            break
            
        case 2:
            cell.lblTitle.text = "Lieblingsessen"
            cell.imgIcon.image = UIImage(named: "fav-icon-default")
            cell.imageName = "fav-icon-default"
            break
            
        case 3:
            if !AppDelegate.isDemoMode {
                cell.lblTitle.text = "Benutzerprofil"
                cell.imgIcon.image = UIImage(named: "profile-icon-default")
                cell.imageName = "profile-icon-default"
            }
            else {
                cell.lblTitle.text = "So funktionert's"
                cell.imgIcon.image = UIImage(named: "settings-icon-default")
                cell.imageName = "settings-icon-default"
            }
            break
            
        case 4:
            if !AppDelegate.isDemoMode {
                cell.lblTitle.text = "So funktionert's"
                cell.imgIcon.image = UIImage(named: "settings-icon-default")
                cell.imageName = "settings-icon-default"
            }
            else {
                return tableView.dequeueReusableCell(withIdentifier: "menuDividerCell")!
            }
            break
            
        case 5:
            if !AppDelegate.isDemoMode {
                cell.lblTitle.text = "Abmelden"
                cell.imgIcon.image = UIImage(named: "logout-icon-default")
                cell.imageName = "logout-icon-default"
            }
            else {
                let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
                c.lblTitle.text = "Freunde einladen"
                return c
            }
            break
            
        case 6:
            if !AppDelegate.isDemoMode {
                return tableView.dequeueReusableCell(withIdentifier: "menuDividerCell")!
            }
            else {
                let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
                c.lblTitle.text = "Folge uns auf Facebook"
                return c
            }
            
        case 7:
            if !AppDelegate.isDemoMode {
                let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
                c.lblTitle.text = "Freunde einladen"
                return c
            }
            else {
                let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
                c.lblTitle.text = "Kontakt"
                return c
            }
            
        case 8:
            if !AppDelegate.isDemoMode {
                let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
                c.lblTitle.text = "Folge uns auf Facebook"
                return c
            }
            else {
                let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
                c.lblTitle.text = "Webseite"
                return c
            }
            
        case 9:
            let c = tableView.dequeueReusableCell(withIdentifier: "menuLinkCell") as! MenuLinkCell
            c.lblTitle.text = "Kontakt"
            return c
            
        case 10:
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
