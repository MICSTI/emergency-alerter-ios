/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    Model for police station.
 */

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
