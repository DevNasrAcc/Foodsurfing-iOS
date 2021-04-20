//
//  MapControlle.swift
//  Foodsurfing
//
//  Created by developer on 14/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapController: UIViewController, GMSMapViewDelegate, RestInfoWindowDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var selectedRest: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = false
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.tiltGestures = false
        self.updateMapCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.clear()
        updateMapCamera()
        
        //Register as Notification receiver
        NotificationCenter.default.addObserver(self, selector: #selector(actOnDataSetChanged), name: NSNotification.Name(rawValue: Constants.notifTagRestDataChange), object: nil)
        
        //Broadcast to Homecontroller for appearance
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifTagHomeControllerChange), object: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func actOnDataSetChanged() {
        mapView.clear()
        updateMapCamera()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateMapCamera() {
        let camera = GMSCameraPosition.camera(withLatitude: Double(LocationInfo.latitude)!, longitude: Double(LocationInfo.longitude)!, zoom: 13.0)
        self.mapView.animate(to: camera)
        self.addPointers()
    }
    
    func addPointers() {
        //Adding current location pointer
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(LocationInfo.latitude)! , longitude: Double(LocationInfo.longitude)!)
        marker.icon = UIImage(named: "current-location-icon")
        marker.map = mapView
        
        for rest in HomeController.restaurants {
            let marker = GMSMarker()
            marker.userData = rest
            marker.position = CLLocationCoordinate2D(latitude: Double.init(rest.latitude ?? "")! , longitude: Double.init(rest.longitude ?? "")!)
//            marker.icon = (rest.marker_icon ?? "") == "http://foodsurfing.eu/images/android/redPin.png" ? UIImage(named: "loc-icon-pink") : UIImage(named: "loc-icon-gray")
            marker.icon = (rest.availability ?? "false") == "true" ? UIImage(named: "loc-icon-pink") : UIImage(named: "loc-icon-gray")
            marker.map = mapView
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? "") == "toRestDetail" {
            let dest = segue.destination as! RestDetailController
            dest.restaurant = self.selectedRest
        }
    }
    
    //MARK: Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        self.mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("My loc tapped!!!")
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let rest = marker.userData as? Restaurant
        guard let restaurant = rest else {
            return true
        }
        Helper.openRestInfoWindow(vc: self, delegate: self, rest: restaurant)
        return true
    }
    
    func infoWindowClosed(rest: Restaurant) {
        self.selectedRest = rest
        performSegue(withIdentifier: "toRestDetail", sender: nil)
    }
    
}
