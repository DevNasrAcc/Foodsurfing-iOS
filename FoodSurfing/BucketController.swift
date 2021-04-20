//
//  BucketController.swift
//  Foodsurfing
//
//  Created by developer on 13/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import Alamofire
import SwiftyJSON

class BucketController: UIViewController, UITableViewDelegate, UITableViewDataSource, ServiceDelegate, BucketDelegate, PaymentModeSelectionDelegate, PayPalPaymentDelegate, VisaPaymentDelegate, OrderConfirmationDelegate {
    
    @IBOutlet weak var lblQtyHeader: UILabel!
    @IBOutlet weak var lblCostHeader: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    var payPalConfig = PayPalConfiguration() // default
    var stripeToken: String?
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSums()
        
        // Set up payPalConfig
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.acceptCreditCards = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.tableFooterView = UIView()
        
        PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentProduction)
    }
    
    func payToPaypal() {
        var items = [PayPalItem]()
        for m in AppDelegate.bucketMeals {
            let item = PayPalItem(name: m.title ?? "", withQuantity: UInt(Int(m.qtySelected ?? "1")!), withPrice: NSDecimalNumber(string: m.price ?? ""), withCurrency: "EUR", withSku: nil)
            items.append(item)
        }
        
        let total = PayPalItem.totalPrice(forItems: items)
        if NSDecimalNumber(string: "0.0") == total {
//            postOrderPaid()
        }
        else {
            let payment = PayPalPayment(amount: total, currencyCode: "EUR", shortDescription: "Foodsurfing Payment", intent: .sale)
            
            if (payment.processable) {
                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                present(paymentViewController!, animated: true, completion: nil)
            }
            else {
                print("Payment not processalbe: \(payment)")
            }
        }
    }
    
    func updateSums() {
        lblQtyHeader.text = "\(AppDelegate.bucketMeals.count)"
        
        //calculating total sum
        var sum: Double = 0.0
        for m in AppDelegate.bucketMeals {
            sum += (Double(m.qtySelected ?? "0")! * Double(m.price ?? "0.0")!)
        }
        lblCostHeader.text = "\(sum)"
    }
    
    @IBAction func btnOrderAction(_ sender: Any) {
        if AppDelegate.isDemoMode {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "loginController")
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        if AppDelegate.bucketMeals.isEmpty {
            Helper.showToast(message: "Keine Artikel zum Warenkorb hinzugefügt")
        }
        else {
            Helper.openPaymentSelectionPopup(vc: self, delegate: self)
        }
    }
    
    func createOrder(paymentMethod: String, paymentId: String) {
        var params: Parameters = [
            "total_quantity"    : lblQtyHeader.text ?? "",
            "total_price"       : lblCostHeader.text ?? "",
            "user_id"           : Helper.getValue(forKey: Constants.userIdKey) ?? "",
            "payment_id"        : paymentId,
            "payment_source"    : paymentMethod
        ]
        
        for (i, m) in AppDelegate.bucketMeals.enumerated() {
            params["meals[\(i)][id]"] = m.id ?? ""
            params["meals[\(i)][quantity]"] = m.qtySelected ?? ""
            params["meals[\(i)][price]"] = m.price ?? ""
        }
        print(params)
        Services.createOrderService(obj: CreateOrderResp.self, delegate: self, params: params)
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lblNotFound.isHidden = AppDelegate.bucketMeals.count > 0
        return AppDelegate.bucketMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bucketCell") as! BucketCell
        let item = AppDelegate.bucketMeals[indexPath.row]
        cell.lblTitle.text = item.title ?? ""
        cell.lblCost.text = "\(item.price ?? "") \(item.currency ?? "")"
        cell.lblQty.text = item.quantity ?? ""
        cell.txtQty.text = item.qtySelected ?? "0"
        let url = URL(string: item.img ?? "")
        cell.imgMeal.kf.setImage(with: url)
        if item.is_favorite ?? true {
            cell.imgFav.image = UIImage(named: "fav-icon-highlight")
        }
        else {
            cell.imgFav.image = UIImage(named: "unfav-icon")
        }
        cell.delegate = self
        cell.mealIndex = indexPath.row
        return cell
    }
    
    func onSuccess(data: Any, serviceID: Service) {
        if serviceID == .postStripePayment {
            let resp = data as! DataResponse<String>
            if resp.response?.statusCode == 200 {
                createOrder(paymentMethod: "credit_card", paymentId: self.stripeToken ?? "")
            }
            else {
                Helper.dismissLoadingView(view: (self.navigationController?.view)!)
            }
        }
        else if serviceID == .createOrder {
            Helper.dismissLoadingView(view: (self.navigationController?.view)!)
            let resp = data as! CreateOrderResp
            if (resp.error ?? "") == "OK" {
                print("Order Created")
                let view = Helper.openOrderConfirmationPopup(vc: self, delegate: self)
                view.lblOrderNumber.text = resp.user_order ?? "0"
            }
            print(resp.error)
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
    }
    
    func onPaymentModeSelection(selectedMethodIndex: Int) {
        if selectedMethodIndex == 1 {
            Helper.openVisaPaymentPopup(vc: self, delegate: self)
        }
        else if selectedMethodIndex == 2 {
            //Paypal
            payToPaypal()
        }
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
            
            //extracting ID
            let data = completedPayment.confirmation as NSDictionary
            var jsonObj = JSON(data)
            let response = jsonObj["response"]
            let id = response["id"].stringValue
            print(id)
            
            //Posting on our server
            self.createOrder(paymentMethod: "paypal", paymentId: id)
        })
    }
    
    func dataChanged() {
        tableview.reloadData()
        updateSums()
    }
    
    func onVisaInfoProvided(cardParams: STPCardParams) {
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                print(error.debugDescription)
                print(error?.localizedDescription)
                Helper.showToast(message: error?.localizedDescription ?? "")
                Helper.dismissLoadingView(view: (self.navigationController?.view)!)
                return
            }
            
            self.stripeToken = token.tokenId
            let amountToSend = (self.lblCostHeader.text ?? "").replacingOccurrences(of: ".", with: "")
            print(amountToSend) //->aString
            print(token.tokenId)
            let params: Parameters = [
                "amount" : amountToSend,
                "source" : token.tokenId
            ]
            Services.postStripePaymentService(delegate: self, params: params)
        }
    }
    
    func orderConfirmed() {
        AppDelegate.bucketMeals = []
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "restaurantNavController")
        self.present(vc, animated: true, completion: nil)
    }
    
}
