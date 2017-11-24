/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    Helper class to load police station information from web API.
 */

import Foundation
import Alamofire
import AlamofireObjectMapper

typealias PoliceStationDownloadCompleteHandler = (_ policeStations: [PoliceStation]?, _ error: Error?) -> Void

public class PoliceLoader {
    
    
    var apiUrl: String;
    
    public init(_ apiUrl: String) {
        self.apiUrl = apiUrl;
    }
    
    func loadFromInternet<T: LocationAware>(current: T, completion: @escaping PoliceStationDownloadCompleteHandler) {
        apiUrl.append("?lat=\(current.latitude)&lng=\(current.longitude)&radius=10000")
        
        Alamofire.request(apiUrl).responseArray { (response: DataResponse<[PoliceStation]>) in
            let policeArray = response.result.value
            
            if let policeArray = policeArray {
                completion(policeArray,nil)
            }else {
                completion([],nil)
            }
        }
        
    }
    
}
