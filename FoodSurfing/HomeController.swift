//
//  HomeController.swift
//  Foodsurfing
//
//  Created by developer on 14/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire
import GooglePlaces

class HomeController: CustBaseController, SliderDelegate, CLLocationManagerDelegate, ServiceDelegate, FilterDelegation {
    
    @IBOutlet weak var lblRestaurant: UILabel!
    @IBOutlet weak var lblMap: UILabel!
    static var restaurants: [Restaurant] = []
    var childPageVC: MyPageViewController?
    var isMapSelected: Bool = false
    var locationManager = CLLocationManager()
    var filterView: FilterView?
    
    override func viewDidLoad() {
        super.selectedScreen = .home
        super.viewDidLoad()
        
        //Location Manager
        self.locationManager.delegate = self
        
        //Calling Service for Data
        if HomeController.restaurants.isEmpty {
            
            Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
            
            //Search for appropriate data
            if LocationInfo.isCurrentLocation {
                getCurrentLocation()
            }
            else if LocationInfo.isFilterApplied {
                searchForLocationCoordinates()
            }
            else {
                searchForLocationCoordinates()
            }
        }
        
        //Adding tap gestures on bottom buttons
        let restGesture = UITapGestureRecognizer(target: self, action: #selector(self.restTapAciton(_:)))
        let mapGesture = UITapGestureRecognizer(target: self, action: #selector(self.mapTapAciton(_:)))
        lblRestaurant.addGestureRecognizer(restGesture)
        lblMap.addGestureRecognizer(mapGesture)
        
        //Adding top right filter button
        let filterIcon = UIImage(named: "filter-icon-white")
        let filterBarButton = UIBarButtonItem(image: filterIcon, style: .done, target: self, action: #selector(filterButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = filterBarButton
        
        //Cart Icon
        let cartIcon = UIImage(named: "cart-icon-white")
        let cartBarButton = UIBarButtonItem(image: cartIcon, style: .done, target: self, action: #selector(cartButtonPressed(_:)))
        self.navigationItem.rightBarButtonItems?.insert(cartBarButton, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(actOnControllerChanged), name: NSNotification.Name(rawValue: Constants.notifTagHomeControllerChange), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var barButtonItem = self.navigationItem.rightBarButtonItems?.first
        if (self.isMapSelected) {
            if let items = self.navigationItem.rightBarButtonItems {
                if items.count > 1 {
                    barButtonItem = items[1]
                }
            }
        }
        Helper.updateBadge(forView: barButtonItem, count: AppDelegate.bucketMeals.count)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func cartButtonPressed(_ sender: UIBarButtonItem ) {
        if AppDelegate.bucketMeals.count > 0 {
            performSegue(withIdentifier: "homeToCart", sender: nil)
        }
    }
    
    func actOnControllerChanged() {
        //Map controller showed
        self.navigateToMap()
    }
    
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted:
                locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
                break
                
            case .denied:
                Helper.dismissLoadingView(view: (self.navigationController?.view)!)
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
                break
                
            }
        }
    }
    
    func addLocationIconToNavBar() {
        let locationIcon = UIImage(named: "location-icon-white")
        let locationBarButton = UIBarButtonItem(image: locationIcon, style: .done, target: self, action: #selector(locationButtonPressed(_:)))
        self.navigationItem.rightBarButtonItems?.insert(locationBarButton, at: 0)
    }
    
    func removeLocationIconFromNavBar() {
        if (self.navigationItem.rightBarButtonItems?.count ?? 0) > 2 {
            self.navigationItem.rightBarButtonItems?.remove(at: 0)
        }
    }
    
    fileprivate func searchForLocationCoordinates() {
        //Find the coordinates for given location
        var address = ""
        if LocationInfo.isFilterApplied {
            if LocationInfo.isCurrentLocation {
                getCurrentLocation()
                return
            }
            else {
                address = "\(LocationInfo.placeName)"
            }
        }
        else {
            address = "\(LocationInfo.placeName) \(LocationInfo.pobox)"
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("lat", coordinates.latitude)
                print("long", coordinates.longitude)
                LocationInfo.latitude = "\(coordinates.latitude.magnitude)"
                LocationInfo.longitude = "\(coordinates.longitude.magnitude)"
            }
            self.callServiceForFilteredRestaurants()
        })
    }
    
    func callServiceForNearbyRestaurants() {
        let params: Parameters = [
            "latitude"  : LocationInfo.latitude,
            "longitude" : LocationInfo.longitude,
            "distance"  : LocationInfo.distance
        ]
        Services.getNearByRestService(obj: RestaurantsResp.self, delegate: self, params: params)
    }
    
    func callServiceForFilteredRestaurants() {
        let params: Parameters = [
            "latitude"      : LocationInfo.latitude,
            "longitude"     : LocationInfo.longitude,
            "distance"      : LocationInfo.distance,
            "opening_time"  : LocationInfo.opening_time,
            "closing_time"  : LocationInfo.closing_time
        ]
        Services.getFilteredRestService(obj: RestaurantsResp.self, delegate: self, params: params)
    }
    
    func filterButtonPressed(_ sender: UIBarButtonItem ) {
        self.filterView = Helper.openFilterPopup(vc: self)
    }
    
    func locationButtonPressed(_ sender: UIBarButtonItem ) {
        LocationInfo.isCurrentLocation = true
        LocationInfo.isFilterApplied = true
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        self.searchForLocationCoordinates()
    }
    
    func navigateToRestScreen() {
        if !isMapSelected {
            return
        }
        self.removeLocationIconFromNavBar()
        lblRestaurant.backgroundColor = Helper.hexStringToUIColor(hex: "b40047")
        lblMap.backgroundColor = UIColor.clear
        childPageVC?.navigateToScreen(withIndex: 0)
        isMapSelected = false
    }
    
    func restTapAciton(_ sender: UITapGestureRecognizer) {
        self.navigateToRestScreen()
    }
    
    func mapTapAciton(_ sender: UITapGestureRecognizer) {
        navigateToMap()
    }
    
    func navigateToMap() {
        if isMapSelected {
            return
        }
        self.addLocationIconToNavBar()
        lblMap.backgroundColor = Helper.hexStringToUIColor(hex: "b40047")
        lblRestaurant.backgroundColor = UIColor.clear
        childPageVC?.navigateToScreen(withIndex: 1)
        isMapSelected = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? "") == "toPageViewController" {
            let vc = segue.destination as! MyPageViewController
            self.childPageVC = vc
            vc.sliderDelegate = self
        }
    }
    
    func showCountryActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Select Deutschland", preferredStyle: .actionSheet)
        
        let englishAction = UIAlertAction(title: "Germany", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.filterView?.txtCountry.text = "Germany"
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(englishAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.view;
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showRegionActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Select Region", preferredStyle: .actionSheet)
        
        let englishAction = UIAlertAction(title: "Nordrhein-Westfalen", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.filterView?.txtRegion.text = "Nordrhein-Westfalen"
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(englishAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.view;
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showCityActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Select City", preferredStyle: .actionSheet)

        let citiesArray: [String] = [
            "Aachen",
            "Bielefeld",
            "Bochum",
            "Bonn",
            "Bottrop",
            "Dortmund",
            "Duisburg",
            "Düsseldorf",
            "Essen",
            "Gelsenkirchen",
            "Hagen",
            "Hamm",
            "Herne",
            "Krefeld",
            "Köln",
            "Leverkusen",
            "Moers",
            "Mülheim an der Ruhr",
            "Münster",
            "Mönchengladbach",
            "Neuss",
            "Oberhausen",
            "Paderborn",
            "Recklinghausen",
            "Remscheid",
            "Siegen",
            "Solingen",
            "Wuppertal"
        ]
        
        for str in citiesArray {
            optionMenu.addAction(getActionMenuItem(name: str))
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.view;
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func getActionMenuItem(name: String) -> UIAlertAction {
        let alertAction = UIAlertAction(title: name, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.filterView?.txtCity.text = name
        })
        return alertAction
    }
    
    //MARK: Delegates
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }
        else {
            Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let lat = location?.coordinate.latitude.magnitude, let lon = location?.coordinate.longitude.magnitude {
            self.locationManager.stopUpdatingLocation()
            LocationInfo.latitude = "\(lat)"
            LocationInfo.longitude = "\(lon)"
            callServiceForFilteredRestaurants()
        }
    }
    
    func didSlide(forIndex: Int) {
        if forIndex == 0 {
            self.removeLocationIconFromNavBar()
            isMapSelected = false
            lblRestaurant.backgroundColor = Helper.hexStringToUIColor(hex: "b40047")
            lblMap.backgroundColor = UIColor.clear
        }
        else if forIndex == 1 {
            self.addLocationIconToNavBar()
            isMapSelected = true
            lblMap.backgroundColor = Helper.hexStringToUIColor(hex: "b40047")
            lblRestaurant.backgroundColor = UIColor.clear
        }
    }
    
    func onSuccess(data: Any, serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        if serviceID == .nearbyRestaurants || serviceID == .filteredRestaurants {
            let resp = data as! RestaurantsResp
            if (resp.error ?? "") == "OK" {
                HomeController.restaurants = resp.restaurants ?? []
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifTagRestDataChange), object: self)
            }
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
    }
    
    func filterApplied() {
        HomeController.restaurants.removeAll()
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifTagRestDataChange), object: self)
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: true)
        self.searchForLocationCoordinates()
    }
    
}
