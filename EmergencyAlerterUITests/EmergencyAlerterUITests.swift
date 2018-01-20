/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    UI test class.
 */

import XCTest

class EmergencyAlerterUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddJohn() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Options"].tap()
        app.navigationBars["Add Contact"]/*@START_MENU_TOKEN@*/.buttons["addContact"]/*[[".buttons[\"Add Contact\"]",".buttons[\"addContact\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tables["ContactsListView"]/*@START_MENU_TOKEN@*/.staticTexts["John Appleseed"]/*[[".cells[\"John Appleseed\"].staticTexts[\"John Appleseed\"]",".staticTexts[\"John Appleseed\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.tables/*@START_MENU_TOKEN@*/.staticTexts["John Appleseed"]/*[[".cells.staticTexts[\"John Appleseed\"]",".staticTexts[\"John Appleseed\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
       
    }
    func testRemove() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Options"].tap()
        
        let johnAppleseedStaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["John Appleseed"]/*[[".cells[\"contactCell\"].staticTexts[\"John Appleseed\"]",".staticTexts[\"John Appleseed\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        johnAppleseedStaticText.swipeLeft()
        app.tables.buttons["Delete"].tap()
        
        XCTAssertFalse(app.tables/*@START_MENU_TOKEN@*/.staticTexts["John Appleseed"]/*[[".cells.staticTexts[\"John Appleseed\"]",".staticTexts[\"John Appleseed\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        
    }
    
}
