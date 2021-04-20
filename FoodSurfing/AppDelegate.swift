//
//  AppDelegate.swift
//  Foodsurfing
//
//  Created by developer on 14/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookCore
import GoogleMaps
import GooglePlaces
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var bucketMeals: [Meal] = []
    static var isDemoMode: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        setApropriateRootController()
        
        //AIzaSyDhTynYTWF4Xgmqu4e1LIuc5MBTfdGlx4M
        GMSServices.provideAPIKey("AIzaSyB2UvcjnuzW0GmvfGoBNPyGROy4WEBZWDc")
        GMSPlacesClient.provideAPIKey("AIzaSyB2UvcjnuzW0GmvfGoBNPyGROy4WEBZWDc")
        
        //PayPal
//        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: "AbcNKcdEAckbO6dJJkUBOt_oHLF9eYXXMTjO1G359I5MZNDL6ucFTJT2L-B9CYQ7-je3ZXFb9QuIkmZP"]) //Sandbox
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "Adwq-f3-srSbcifMxfI28__Z2GjdJ0-FYgUH9-iKN9W6rBhaV67AfsP6SL0a5f5nA24t8VbJjwDDoeJy"]) //Live
        
        // Stripe Configuration
//        STPPaymentConfiguration.shared().publishableKey = "pk_test_5jILCvHK5szaqeLoPH8Yavhq" //sandbox
        STPPaymentConfiguration.shared().publishableKey = "pk_live_weKMGNtFS7SfMpaKZ0rGCAMF" //live
        
        //Facebook
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let fbDidHandle = SDKApplicationDelegate.shared.application(application, open: url, options: options)
        return fbDidHandle
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //custom
    func setApropriateRootController() {
        if !(Helper.getValue(forKey: Constants.tokenKey) ?? "").isEmpty {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if Helper.getValue(forKey: Constants.userRole) ?? "" == "rest" {
                let vc = sb.instantiateViewController(withIdentifier: "restNavController") as! UINavigationController
                self.window!.rootViewController = vc
            }
            else {
                let vc = sb.instantiateViewController(withIdentifier: "locationNavController") as! UINavigationController
                self.window!.rootViewController = vc
            }
        }
    }

}
