//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Erik Olson on 9/28/17.
//  Copyright © 2017 Erik Olson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
 
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var pinAnnotationView: MKPinAnnotationView!
    
    override func loadView(){
        // create a map view
        mapView = MKMapView()
        
        locationManager = CLLocationManager()
        
        pinAnnotationView = MKPinAnnotationView()
        
        // set it as 'the' map view for the view controller
        view = mapView
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
     
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let margins = view.layoutMarginsGuide
        
        let topConstraintSC = segmentedControl.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20)
        let leadingConstraintSC = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraintSC = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraintSC.isActive = true
        leadingConstraintSC.isActive = true
        trailingConstraintSC.isActive = true
        
        let locationButton = UIButton(type: .custom)
        locationButton.alpha = 0.5
        locationButton.setBackgroundImage(#imageLiteral(resourceName: "CrosshairIcon"), for: .normal)
        
        locationButton.addTarget(self, action: #selector(MapViewController.zoomToUser(_:)), for: .touchUpInside)
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
        
        let bottomConstraintLB = locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        let trailingConstraintLB = locationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        bottomConstraintLB.isActive = true
        trailingConstraintLB.isActive = true
        
        view.addSubview(pinAnnotationView)
        let pinLocation = CLLocationCoordinate2DMake(40.73, -74)
        let pin = MKPointAnnotation()
        pin.coordinate = pinLocation
        mapView.addAnnotation(pin)
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0: mapView.mapType = .standard
        case 1: mapView.mapType = .hybrid
        case 2: mapView.mapType = .satellite
        default: break
        }
    }
    
    @objc func zoomToUser(_: UIButton) {
        
        if let userLocation = mapView.userLocation.location?.coordinate {
            mapView.setCenter(userLocation, animated: true)
            mapView.setRegion(MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)), animated: true)
        }
    }
    
}
