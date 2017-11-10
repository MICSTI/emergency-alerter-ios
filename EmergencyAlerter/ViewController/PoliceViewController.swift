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

class PoliceViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!

    var locationManager = CLLocationManager()
    

    var polices = [PoliceStation] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lat: CLLocationDegrees = 47.44074
        let lon: CLLocationDegrees = 15.328767
        let latDelta: CLLocationDegrees = 0.1
        let lonDelta: CLLocationDegrees = 0.1

        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.map.setRegion(region, animated: true)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        // set user location on map
        let userLocation: CLLocation = locations[0]
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        let span = MKCoordinateSpan()
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
        
        // add pin (Annotation)
        let myPosLabel = MKPointAnnotation()
        myPosLabel.coordinate = location
        myPosLabel.title = "You are here"
        self.map.addAnnotation(myPosLabel)
        
        //save last location, compare, if greater than threshold reload police
        
        let policeLoader = PoliceLoader("https://crpladev-emal.herokuapp.com/api/nearest/police");
        policeLoader.loadFromInternet(current: CurrentLocation(lat,lon)) { (polices, err) in
            print("Finished loading")
            print("\(polices)")
            
        }
    
    }
    
}
