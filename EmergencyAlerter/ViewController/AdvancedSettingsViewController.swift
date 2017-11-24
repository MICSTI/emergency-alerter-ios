/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
 A view controller for the advanced settings
 */


import UIKit

class AdvancedSettingsViewController: UIViewController {
    
    @IBOutlet weak var callOnShakeSwitch: UISwitch!
    @IBOutlet weak var emergencyNumberField: UITextField!
    @IBOutlet weak var vibrateOnCallSwitch: UISwitch!
    @IBOutlet weak var vibrateOnMessageSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO When Button is toggled, save param
    
    //TODO When Number is edited, save param
    
}



