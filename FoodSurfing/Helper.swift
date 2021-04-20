//
//  Helper.swift
//  Foodsurfing
//
//  Created by developer on 18/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import SideMenu
import Toaster
import SystemConfiguration

class Helper {
    
    class func showToast(message: String) {
        Toast.init(text: message).show()
    }
    
    class func setupMenu(controller: UIViewController, menuDelegate: MenuDelegate, selectedScreen: MenuItem, isRestaurant: Bool) {
        let menuLeftNavigationController: UISideMenuNavigationController
        if isRestaurant {
            menuLeftNavigationController = (controller.storyboard!.instantiateViewController(withIdentifier: "leftMenuNavController") as? UISideMenuNavigationController)!
            let vc = menuLeftNavigationController.viewControllers[0] as! RestMenuController
            vc.menuDelegate = menuDelegate
            vc.selectedScreen = selectedScreen
        }
        else {
            menuLeftNavigationController = (controller.storyboard!.instantiateViewController(withIdentifier: "leftMenuNavController2") as? UISideMenuNavigationController)!
            let vc = menuLeftNavigationController.viewControllers[0] as! CustMenuController
            vc.menuDelegate = menuDelegate
            vc.selectedScreen = selectedScreen
        }
                
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.menuAddPanGestureToPresent(toView: controller.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: controller.navigationController!.view)
        SideMenuManager.menuFadeStatusBar = false
    }
    
    class func setKey(key: String, value: String) {
        let pref = UserDefaults.standard
        pref.set(value, forKey: key)
    }
    
    class func getValue(forKey: String) -> String? {
        let pref = UserDefaults.standard
        return pref.string(forKey: forKey)
    }
    
    class func openCalendar(vc: UIViewController, mode: UIDatePickerMode = .date) {
        let calView = CalendarView.instanceFromNib(del: vc as! DateSelectionDelegate) as! CalendarView
        calView.datePicker.datePickerMode = mode
        calView.frame.size = CGSize(width: vc.view.frame.width - 32, height: calView.frame.height)
        calView.center = CGPoint(x: vc.view.frame.size.width  / 2, y: vc.view.frame.size.height / 2);
        vc.view.addSubview(calView)
    }
    
    class func openFilterPopup(vc: UIViewController) -> FilterView {
        //Transparent Layer
        let v = (vc.navigationController ?? vc).view!
        let transPoint      = CGPoint(x: v.frame.minX, y: v.frame.minY)
        let transRect       = CGRect(origin: transPoint, size: v.frame.size)
        let transView       = UIView(frame: transRect)
        transView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5))
        transView.tag = Constants.tagTransLayer
        v.addSubview(transView)
        
        //Adding filter view
        let filterView = FilterView.instanceFromNib() as! FilterView
        filterView.frame.size = CGSize(width: v.frame.width - 16, height: v.frame.height * 0.85)
        filterView.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2)
        transView.addSubview(filterView)
        
        return filterView
        //Adding tap gesture to transView
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Helper.tapAction(recognizer:)))
        //        transView.addGestureRecognizer(tapGesture)
    }
    
    class func openPaymentSelectionPopup(vc: UIViewController, delegate: PaymentModeSelectionDelegate) -> PaymentModeSelectionView {
        //Transparent Layer
        let v = (vc.navigationController ?? vc).view!
        let transPoint      = CGPoint(x: v.frame.minX, y: v.frame.minY)
        let transRect       = CGRect(origin: transPoint, size: v.frame.size)
        let transView       = UIView(frame: transRect)
        transView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5))
        transView.tag = Constants.tagTransLayer
        v.addSubview(transView)
        
        //Adding filter view
        let paymentSelectionView = PaymentModeSelectionView.instanceFromNib() as! PaymentModeSelectionView
        paymentSelectionView.frame.size = CGSize(width: v.frame.width - 16, height: v.frame.height * 0.5)
        paymentSelectionView.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2)
        paymentSelectionView.delegate = delegate
        transView.addSubview(paymentSelectionView)
        
        return paymentSelectionView
    }
    
    class func openVisaPaymentPopup(vc: UIViewController, delegate: VisaPaymentDelegate) -> VisaPaymentView {
        //Transparent Layer
        let v = (vc.navigationController ?? vc).view!
        let transPoint      = CGPoint(x: v.frame.minX, y: v.frame.minY)
        let transRect       = CGRect(origin: transPoint, size: v.frame.size)
        let transView       = UIView(frame: transRect)
        transView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5))
        transView.tag = Constants.tagTransLayer
        v.addSubview(transView)
        
        //Adding filter view
        let visaView = VisaPaymentView.instanceFromNib() as! VisaPaymentView
        visaView.frame.size = CGSize(width: v.frame.width - 16, height: v.frame.height * 0.85)
        visaView.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2)
        visaView.delegate = delegate
        transView.addSubview(visaView)
        
        return visaView
    }
    
    class func openOrderConfirmationPopup(vc: UIViewController, delegate: OrderConfirmationDelegate) -> OrderConfirmationView {
        //Transparent Layer
        let v = (vc.navigationController ?? vc).view!
        let transPoint      = CGPoint(x: v.frame.minX, y: v.frame.minY)
        let transRect       = CGRect(origin: transPoint, size: v.frame.size)
        let transView       = UIView(frame: transRect)
        transView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5))
        transView.tag = Constants.tagTransLayer
        v.addSubview(transView)
        
        //Adding filter view
        let confirmationView = OrderConfirmationView.instanceFromNib() as! OrderConfirmationView
        confirmationView.frame.size = CGSize(width: v.frame.width - 16, height: v.frame.height * 0.5)
        confirmationView.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2)
        confirmationView.delegate = delegate
        transView.addSubview(confirmationView)
        
        return confirmationView
    }
    
    class func openRestInfoWindow(vc: UIViewController, delegate: RestInfoWindowDelegate, rest: Restaurant) -> RestInfoWindow {
        //Transparent Layer
        let v = (vc.navigationController ?? vc).view!
        let transPoint      = CGPoint(x: v.frame.minX, y: v.frame.minY)
        let transRect       = CGRect(origin: transPoint, size: v.frame.size)
        let transView       = UIView(frame: transRect)
        transView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5))
        transView.tag = Constants.tagTransLayer
        v.addSubview(transView)
        
        //Adding filter view
        let infoWindow = RestInfoWindow.instanceFromNib(rest: rest) as! RestInfoWindow
        infoWindow.frame.size = CGSize(width: v.frame.width - 16, height: 170)
        infoWindow.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2)
        infoWindow.delegate = delegate
        transView.addSubview(infoWindow)
        
        //Adding tap gesture to transView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Helper.tapAction(recognizer:)))
        transView.addGestureRecognizer(tapGesture)
        
        return infoWindow
    }
    
    class func DateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        return dateFormatter.string(from: date)
    }
    
    class func stringToDate(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: str)
    }
    
    class func customDateFormatter(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h a"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func addLoading(view: UIView, isRemovable: Bool) {
        
        //Transparent Layer
        let transPoint      = CGPoint(x: view.frame.minX, y: view.frame.minY)
        let transRect       = CGRect(origin: transPoint, size: view.frame.size)
        let transView       = UIView(frame: transRect)
        transView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.4))
        transView.tag = Constants.tagTransLayer
        view.addSubview(transView)
        
        //Loading Spinner view
        let spinner = LoadingView.instanceFromNib()
        spinner.center = view.center
        transView.addSubview(spinner)
        
        //Tap Gesture
        if isRemovable {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Helper.tapAction(recognizer:)))
            transView.addGestureRecognizer(tapGesture)
        }
    }
    
    class func dismissLoadingView(view: UIView) {
        view.viewWithTag(Constants.tagTransLayer)?.removeFromSuperview()
    }
    
    static func updateBadge(forView: UIBarButtonItem?, count: Int) {
        guard let view = forView else {
            return
        }
        
        if count == 0 {
            view.badge(text: nil)
            return
        }
        
        //Badge setting
        var badgeAppearance = BadgeAppearance()
        badgeAppearance.distanceFromCenterX = CGFloat(-12)
        badgeAppearance.distanceFromCenterY = CGFloat(-10)
        badgeAppearance.textColor = Helper.hexStringToUIColor(hex: "b40047")
        badgeAppearance.backgroundColor = UIColor.white
        view.badge(text: "\(count)", appearance: badgeAppearance)
    }
    
    @objc class func tapAction(recognizer: UITapGestureRecognizer) {
        recognizer.view?.removeFromSuperview()
    }
    
    static func shareByWhatsapp(msg: String, vc: UIViewController){
        let message = "Let me recommend you Foodsurfing application \n\r \n\rDownload it from here: https://itunes.apple.com/us/app/foodsurfing/id1311671255?ls=1&mt=8"
        let urlWhats = "whatsapp://send?text=\(message)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.openURL(whatsappURL as URL)
                } else {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Whatsapp not found", comment: "Error message"),
                                                  message: NSLocalizedString("Could not found a installed app 'Whatsapp' to proceed with sharing.", comment: "Error description"),
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert button"), style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                    }))
                    
                    vc.present(alert, animated: true, completion:nil)
                    // Cannot open whatsapp
                }
            }
        }
    }
    
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}


extension UITextField {
    @IBInspectable var placeholderColor: UIColor {
        get {
            guard let currentAttributedPlaceholderColor = attributedPlaceholder?.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: nil) as? UIColor else { return UIColor.clear }
            return currentAttributedPlaceholderColor
        }
        set {
            guard let currentAttributedString = attributedPlaceholder else { return }
            let attributes = [NSForegroundColorAttributeName : newValue]
            
            attributedPlaceholder = NSAttributedString(string: currentAttributedString.string, attributes: attributes)
        }
    }
}
