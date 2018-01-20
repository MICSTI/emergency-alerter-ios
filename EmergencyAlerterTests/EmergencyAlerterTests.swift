//
//  EmergencyAlerterTests.swift
//  EmergencyAlerterTests
//
//  Created by Arlinda Butja on 20/01/2018.
//  Copyright © 2018 T11. All rights reserved.
//

import XCTest
@testable import EmergencyAlerter

typealias PoliceStationDownloadCompleteHandler = (_ policeStations: [PoliceStation]?, _ error: Error?) -> Void


class EmergencyAlerterTests: XCTestCase {
    
    var policeLoader: PoliceLoader!
    
    override func setUp() {
        super.setUp()
        policeLoader = PoliceLoader("https://crpladev-emal.herokuapp.com/api/nearest/police");
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
       let ex = expectation(description: "Load from inet")
        policeLoader.loadFromInternet(current: CurrentLocation(47.076668,15.421371)) { (polices, err) in
            XCTAssertNotNil(polices)
            XCTAssertNil(err)
            ex.fulfill()
        }
        waitForExpectations(timeout: 20, handler: { (err) in
            if let e = err {
                print("Timeout with error \(e)")
            } else {
                print("Success")
            }
            
        })
        
        
    }
    
    
    
    
}
