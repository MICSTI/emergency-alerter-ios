//
//  PoliceStation.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 08/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper 

public class PoliceStation : Mappable {
    
    
     var name: String?;
     var latitude: Double?;
     var longitude: Double?;
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        self.name <- map["name"]
        self.latitude <- map["location.lat"]
        self.longitude <- map["location.lng"]
    }
    
    
}
