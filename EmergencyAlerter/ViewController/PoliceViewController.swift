/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    A view controller that displays nearby police stations together with the current position of the user.
 */

import UIKit
import CoreLocation
import MapKit

// Wrapper for lng and lat of current position
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
    
    let policeLoader = PoliceLoader("https://crpladev-emal.herokuapp.com/api/nearest/police");
    var locationManager = CLLocationManager()
    
    var policeStations = [PoliceStation] ()
    var currentLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    var originalLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    var myPosLabel = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Init locationmanager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Init map
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Drawing the map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        let allAnnotations = self.map.annotations
        let userLocation: CLLocation = locations[0]
        
        //Update position only if user moved
        if(userLocation.distance(from: currentLocation) < 2) {
            return
        }
        currentLocation = userLocation
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        
        //Reload police stations only if user travelled more than 200m. Saves energy because of less network calls
        let distanceFromOriginal = originalLocation.distance(from: currentLocation)
        if(distanceFromOriginal > 200){
            map.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), animated: false)
            originalLocation = currentLocation
            //Reset Map, Remove markers
            self.map.removeAnnotations(allAnnotations)
            
            //Use Grand Central Dispatch for Async load of Webservice
            //AlamoFire itself already uses it, this is here for learning and presentation purposes
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.policeLoader.loadFromInternet(current: CurrentLocation(lat,lon)) { (polices, err) in
                        for police in polices! {
                            let policeLabel = MKPointAnnotation()
                            policeLabel.coordinate = CLLocationCoordinate2D(latitude: police.latitude!, longitude: police.longitude!)
                            policeLabel.title = police.name
                            self.map.addAnnotation(policeLabel)
                        }
                    }
                }
            }
            
        }
        
        //Update current user location
        self.map.removeAnnotation(myPosLabel)
        myPosLabel.coordinate = currentLocation.coordinate
        myPosLabel.title = "You are here"
        self.map.addAnnotation(myPosLabel)
    }
   
    
}
