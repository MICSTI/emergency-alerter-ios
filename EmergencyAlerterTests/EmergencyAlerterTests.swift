/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    Unit Test Class for testing the connection to the PoliceAPI
 */

import XCTest
@testable import EmergencyAlerter

typealias PoliceStationDownloadCompleteHandler = (_ policeStations: [PoliceStation]?, _ error: Error?) -> Void


class EmergencyAlerterTests: XCTestCase {
    
    var policeLoader: PoliceLoader!
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        policeLoader = nil;
    }
    
    func testCallApiSuccess() {
       policeLoader = PoliceLoader("https://crpladev-emal.herokuapp.com/api/nearest/police");
        let ex = expectation(description: "Load from inet")
        policeLoader.loadFromInternet(current: CurrentLocation(47.076668,15.421371)) { (polices, err) in
            XCTAssertNotNil(polices)
            XCTAssertTrue(polices!.count>0)
            ex.fulfill()
        }
        waitForExpectations(timeout: 10, handler: { (err) in
            if let e = err {
                print("Timeout with error \(e)")
            } else {
                print("Success")
            }
            
        })
    }
    
    func testCallApiNoSuccess() {
        policeLoader = PoliceLoader("https://crpladev-emal.herokuapp.com/api/nearest/wrong");
        let ex = expectation(description: "Load from inet")
        policeLoader.loadFromInternet(current: CurrentLocation(47.076668,15.421371)) { (polices, err) in
            XCTAssertNotNil(polices)
            XCTAssertTrue(polices!.count==0)
            ex.fulfill()
        }
        waitForExpectations(timeout: 10, handler: { (err) in
            if let e = err {
                print("Timeout with error \(e)")
            } else {
                print("Success")
            }
            
        })
        
        
    }
    
    
    
    
}
