//
//  GeoLocation.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 08/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import Foundation
public protocol LocationAware {
    var latitude: Double {get set}
    var longitude: Double {get set}
    
    func getLocation() -> (lat: Double, long: Double)
    
}
