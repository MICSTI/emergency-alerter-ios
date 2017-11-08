//
//  PoliceLoader.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 08/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias PoliceStationDownloadCompleteHandler = (_ policeStations: [PoliceStation]?, _ error: Error?) -> Void

public class PoliceLoader {
    
    
    var apiUrl: String;
    
    public init(_ apiUrl: String) {
        self.apiUrl = apiUrl;
    }
    
    func loadFromInternet<T: LocationAware>(current: T, completion: @escaping PoliceStationDownloadCompleteHandler) {
        
        apiUrl.append("?lat=\(current.latitude)&lng=\(current.longitude)&radius=10000")
        
        Alamofire.request(apiUrl).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                //map json.data
                
                completion([],nil)
            case .failure(let error):
                print(error)
                completion(nil,error)
            }
        }
        
    }
    
}
