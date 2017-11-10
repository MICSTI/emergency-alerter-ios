//
//  PoliceLoader.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 08/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

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
        print("do somethign")
        apiUrl.append("?lat=\(current.latitude)&lng=\(current.longitude)&radius=10000")
        
        Alamofire.request(apiUrl).responseArray { (response: DataResponse<[PoliceStation]>) in
            print(response)
            let policeArray = response.result.value
            
            if let policeArray = policeArray {
                for policeStation in policeArray {
                    print(policeStation)
                    completion([],nil)
                }
            }
        }
        
        /*Alamofire.request(apiUrl).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
              
               
                
            
                completion([],nil)
            case .failure(let error):
                print(error)
                completion(nil,error)
            }
        }*/
        
    }
    
}
