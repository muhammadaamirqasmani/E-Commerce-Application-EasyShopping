//
//  MapVC.swift
//  EasyShopping
//
//  Created by admin on 21/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import UIKit
import GoogleMaps


class MapVC: UIViewController,GMSMapViewDelegate {

    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var camera: GMSCameraPosition!
    
    var variableLongitudeMap = Double()
    var variableLatitudeMap = Double()
    var variableItemName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        let camera = GMSCameraPosition.camera(withLatitude: variableLatitudeMap, longitude: variableLongitudeMap, zoom: 15)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        let button = UIButton(frame: CGRect(x: 15, y: 15, width: 40, height: 25))
        button.backgroundColor = .gray
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tag = 0
        button.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: variableLatitudeMap, longitude: variableLongitudeMap)
        print("Latitude \(variableLatitudeMap) and Longitude \(variableLongitudeMap)")
        marker.title = "Seller of \(variableItemName) here"
        marker.snippet = "This is The seller location"
        marker.tracksInfoWindowChanges = true
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.map = mapView

    }
    @objc func pressButton(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
        print("Button with tag: \(button.tag) clicked!")
    }
    
}
extension MapVC: CLLocationManagerDelegate{
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
        print("Location: \(String(describing: location))")
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15)
        
        if mapView.isHidden {
            mapView.isHidden = false
        
            mapView.camera = camera
        } else {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
            marker.title = "User Here"
            marker.snippet = "This is your location"
//            marker.tracksInfoWindowChanges = true
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.icon = GMSMarker.markerImage(with: .blue)
            marker.map = mapView
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}

