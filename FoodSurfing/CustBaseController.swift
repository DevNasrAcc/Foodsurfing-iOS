//
//  CustBaseController.swift
//  Foodsurfing
//
//  Created by developer on 27/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class CustBaseController: UIViewController, MenuDelegate {
    
    var selectedScreen: MenuItem = MenuItem.home
    var isRest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup menu
        Helper.setupMenu(controller: self, menuDelegate: self, selectedScreen: selectedScreen, isRestaurant: self.isRest)
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "menuIcon"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(self.menuButtonPressed), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func menuButtonPressed() {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    //MARK: Delegates
    
    func onMenuItemSelection(screenId: MenuItem) {
        dismiss(animated: true, completion: nil)
        
        if screenId == selectedScreen {
            return
        }
        
        if AppDelegate.isDemoMode {
            if screenId == .favorites || screenId == .orders {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        
        switch screenId {
        case .logout:
            Helper.setKey(key: Constants.tokenKey, value: "")
            Helper.setKey(key: Constants.userIdKey, value: "")
            AppDelegate.bucketMeals.removeAll()
            HomeController.restaurants.removeAll()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginController")
            self.present(vc!, animated: true, completion: nil)
            break
            
        case .profile:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileNavController")
            self.present(vc!, animated: true, completion: nil)
            break
            
        case .settings:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "settingsNavController")
            self.present(vc!, animated: true, completion: nil)
            break
            
        case .bookings:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "restNavController")
            self.present(vc!, animated: true, completion: nil)
            break
            
        case .statistics:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "statsNavController")
            self.present(vc!, animated: true, completion: nil)
            break
            
        case .home:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "restaurantNavController")
            self.present(vc!, animated: true, completion: nil)
            break
            
        case .orders:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ordersNavController")
            self.present(vc!, animated: true, completion: nil)
            break
            
        case .favorites:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "favoriteNavController")
            self.present(vc!, animated: true, completion: nil)
            break
            
        case .howWorks:
            let vc = UIStoryboard(name: "HowItWorks", bundle: nil).instantiateViewController(withIdentifier: "howItWorksController")
            self.present(vc, animated: true, completion: nil)
            break
        }
    }
    
}
