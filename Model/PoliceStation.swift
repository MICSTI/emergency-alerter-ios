//
//  PoliceStation.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 08/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import Foundation
import CoreLocation


public class PoliceStation : LocationAware {
    
    private var name: String;
    public var latitude: Double;
    public var longitude: Double;
    
    public init(_ name: String, _ lat: Double, _ long: Double) {
        self.latitude = lat
        self.longitude = long
        self.name = name
        
    }
    
    convenience init(_ name : String) {
        self.init(name, 12.34, 56.78);
    }
    
    public func getLocation() -> (lat: Double, long: Double) {
        return (self.latitude, self.longitude);
    }
    
    //Generics
    public func getDistanceFromHere<T: LocationAware>(other: T) -> Double {
        let selfPosition = CLLocation(latitude: self.latitude, longitude: self.longitude);
        let otherPosition = CLLocation(latitude: other.latitude, longitude: other.longitude);
        return selfPosition.distance(from: otherPosition);
    }
    
    
    
    static func -(left: PoliceStation, right: PoliceStation) -> Double {
        return left.getDistanceFromHere(other: right);
    }
    
}
