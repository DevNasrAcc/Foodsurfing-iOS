//
//  FilterView.swift
//  Foodsurfing
//
//  Created by developer on 12/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import TTRangeSlider

class FilterView: UIView, TTRangeSliderDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblDistMinRange: UILabel!
    @IBOutlet weak var lblDistMaxRange: UILabel!
    @IBOutlet weak var lblTimeMinRange: UILabel!
    @IBOutlet weak var lblTimeMaxRange: UILabel!
    @IBOutlet weak var sliderDistance: TTRangeSlider!
    @IBOutlet weak var sliderTime: TTRangeSlider!
    @IBOutlet weak var firstLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchLocation: UISwitch!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtRegion: UITextField!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblLand: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    
    class func instanceFromNib() -> UIView {
        let instance = UINib(nibName: "FilterPopupView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterView
        instance.sliderTime.delegate = instance
        instance.sliderDistance.delegate = instance
        instance.txtCountry.delegate = instance
        instance.txtCity.delegate = instance
        instance.txtRegion.delegate = instance
        instance.sliderTime.tintColorBetweenHandles = Helper.hexStringToUIColor(hex: "D61A6A")
        instance.sliderDistance.tintColorBetweenHandles = Helper.hexStringToUIColor(hex: "D61A6A")
        instance.sliderTime.handleColor = Helper.hexStringToUIColor(hex: "D61A6A")
        instance.sliderDistance.handleColor = Helper.hexStringToUIColor(hex: "D61A6A")
        
        //Update data
        instance.switchLocation.isOn = LocationInfo.isCurrentLocation
        instance.txtCity.text = LocationInfo.city
        instance.txtRegion.text = LocationInfo.region
        instance.txtCountry.text = LocationInfo.country
        instance.sliderDistance.selectedMinimum = Float(LocationInfo.min_distance) ?? Float(0)
        instance.sliderDistance.selectedMaximum = Float(LocationInfo.distance) ?? Float(100)
        instance.lblDistMinRange.text = LocationInfo.min_distance
        instance.lblDistMaxRange.text = LocationInfo.distance
        instance.lblTimeMinRange.text = "\(String(describing: LocationInfo.opening_time.components(separatedBy: ":").first ?? "00")):00"
        instance.lblTimeMaxRange.text = "\(String(describing: LocationInfo.closing_time.components(separatedBy: ":").first ?? "24")):00"
        instance.sliderTime.selectedMinimum = Float(String(describing: LocationInfo.opening_time.components(separatedBy: ":").first ?? "00")) ?? Float(0)
        instance.sliderTime.selectedMaximum = Float(String(describing: LocationInfo.closing_time.components(separatedBy: ":").first ?? "24")) ?? Float(24)
        
        instance.updateViewsOnLocationSwitch()
        
        
        return instance
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.superview?.removeFromSuperview()
    }
    
    
    @IBAction func btnDoneAction(_ sender: Any) {
        
        let homeVC = (self.viewController() as! UINavigationController).viewControllers.first as! HomeController
        LocationInfo.isFilterApplied = true
        LocationInfo.isCurrentLocation = switchLocation.isOn
        LocationInfo.min_distance = lblDistMinRange.text ?? "0"
        LocationInfo.distance = lblDistMaxRange.text ?? "100"
        LocationInfo.opening_time = "\(lblTimeMinRange.text ?? "00:00"):00"
        LocationInfo.closing_time = "\(lblTimeMaxRange.text ?? "24:00"):00"
        LocationInfo.city = txtCity.text ?? ""
        LocationInfo.region = txtRegion.text ?? ""
        LocationInfo.country = txtCountry.text ?? ""
        
        if !switchLocation.isOn {
            LocationInfo.placeName = "\(txtCity.text ?? "") \(txtRegion.text ?? "") \(txtCountry.text ?? "")"
        }
        
        homeVC.filterApplied()
        self.superview?.removeFromSuperview()
    }
    
    
    @IBAction func switchLocationAction(_ sender: Any) {
        self.updateViewsOnLocationSwitch()
    }
    
    func updateViewsOnLocationSwitch() {
        if switchLocation.isOn {
            firstLineHeightConstraint.constant = CGFloat(0)
            txtRegion.isHidden = true
            txtCountry.isHidden = true
            txtCity.isHidden = true
            lblRegion.isHidden = true
            lblLand.isHidden = true
            lblCity.isHidden = true
        }
        else {
            firstLineHeightConstraint.constant = CGFloat(55)
            txtRegion.isHidden = false
            txtCountry.isHidden = false
            txtCity.isHidden = false
            lblRegion.isHidden = false
            lblLand.isHidden = false
            lblCity.isHidden = false
        }
    }
    
    func didEndTouches(in sender: TTRangeSlider!) {
        if sender == sliderDistance {
            lblDistMinRange.text = "\(Int(sender.selectedMinimum))"
            lblDistMaxRange.text = "\(Int(sender.selectedMaximum))"
        }
        else if sender == sliderTime {
            lblTimeMinRange.text = "\(Int(sender.selectedMinimum)):00"
            lblTimeMaxRange.text = "\(Int(sender.selectedMaximum)):00"
        }
    }
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let homeVC = (self.viewController() as! UINavigationController).viewControllers.first as! HomeController
        if textField == txtCountry {
            homeVC.showCountryActionSheet()
        }
        else if textField == txtRegion {
            homeVC.showRegionActionSheet()
        }
        else if textField == txtCity {
            homeVC.showCityActionSheet()
        }
        return false
    }
}
