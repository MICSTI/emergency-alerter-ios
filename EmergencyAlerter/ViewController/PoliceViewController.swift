//
//  ViewController.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 07/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CurrentLocation: LocationAware{
    public var latitude: Double;
    public var longitude: Double;
    
   
    
    public init(_ lat: Double, _ long: Double) {
        self.latitude = lat
        self.longitude = long
    }
    
    public func getLocation() -> (lat: Double, long: Double) {
        return (self.latitude, self.longitude);
    }
}

extension MKPinAnnotationView {
    class func blue() -> UIColor {
        return UIColor.blue
    }
}

class PoliceViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!

    var locationManager = CLLocationManager()
    
    var policeStations = [PoliceStation] ()
    var currentLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    var originalLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    var myPosLabel = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        let allAnnotations = self.map.annotations
        
        let userLocation: CLLocation = locations[0]
        
        if(userLocation.distance(from: currentLocation) < 2) {
            return
        }
        print("updating small")
        currentLocation = userLocation
        
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        

        
        //save last location, compare, if greater than threshold reload police
        let distanceFromOriginal = originalLocation.distance(from: currentLocation)
        print(" distance \(distanceFromOriginal)")

        if(distanceFromOriginal > 200){
            map.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), animated: false)
            originalLocation = currentLocation
            self.map.removeAnnotations(allAnnotations)
            let policeLoader = PoliceLoader("https://crpladev-emal.herokuapp.com/api/nearest/police");
            policeLoader.loadFromInternet(current: CurrentLocation(lat,lon)) { (polices, err) in
                for police in polices! {
                    let policeLabel = MKPointAnnotation()
                    policeLabel.coordinate = CLLocationCoordinate2D(latitude: police.latitude!, longitude: police.longitude!)
                    policeLabel.title = police.name
                    self.map.addAnnotation(policeLabel)
                }
            }
            
        }
        
        self.map.removeAnnotation(myPosLabel)
        // add pin (Annotation)
        myPosLabel.coordinate = currentLocation.coordinate
        myPosLabel.title = "You are here"
        self.map.addAnnotation(myPosLabel)
        
    }
   
    
}
