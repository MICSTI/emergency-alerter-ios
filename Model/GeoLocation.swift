/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    Models a GeoLocation including latitude and longitude.
 */

import Foundation
public protocol LocationAware {
    var latitude: Double {get set}
    var longitude: Double {get set}
    
    func getLocation() -> (lat: Double, long: Double)
    
}
