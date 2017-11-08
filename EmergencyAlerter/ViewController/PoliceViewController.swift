//
//  ViewController.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 07/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import UIKit

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

class PoliceViewController: UIViewController {
    var polices = [PoliceStation] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        let policeLoader = PoliceLoader("https://crpladev-emal.herokuapp.com/api/nearest/police");
        policeLoader.loadFromInternet(current: CurrentLocation(47.43333,15.28333)) { (polices, err) in
            print("Finished loading")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
