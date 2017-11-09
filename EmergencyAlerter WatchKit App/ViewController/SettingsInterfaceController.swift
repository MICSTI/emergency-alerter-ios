
//
//  SettingsInterfaceController
//  EmergencyAlerter WatchKit Extension
//
//  Created by Mayerhofer Florian on 07/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import WatchKit
import Foundation

class SettingsInterfaceController: WKInterfaceController {
    
    @IBOutlet var heartrateSwitch: WKInterfaceSwitch!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        heartrateSwitch.setOn(loadIsHeartrateActivated())
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func toggleHeartrateSwitch(_ value: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: "heartRateActive")
    }
     
    func loadIsHeartrateActivated()->Bool{
        let userDefaults = UserDefaults.standard
        if let isActive = userDefaults.value(forKey: "heartRateActive"){
            print("Active: \(isActive)")
            return isActive as! Bool
        }else {
            return false
        }
    }
    
}


