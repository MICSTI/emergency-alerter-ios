/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
 A view controller for the advanced settings
 */


import UIKit
class AdvancedSettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var callOnShakeSwitch: UISwitch!
    @IBOutlet weak var emergencyNumberField: UITextField!
    @IBOutlet weak var vibrateOnCallSwitch: UISwitch!
    @IBOutlet weak var vibrateOnMessageSwitch: UISwitch!

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        callOnShakeSwitch.addTarget(self, action: #selector(shakeSwitchChanged), for: UIControlEvents.valueChanged)
        callOnShakeSwitch.setOn(defaults.bool(forKey: "callOnShake"), animated: true)
        
        vibrateOnCallSwitch.addTarget(self, action: #selector(vibrateCallChanged), for: UIControlEvents.valueChanged)
        vibrateOnCallSwitch.setOn(defaults.bool(forKey: "vibrateOnCall"), animated: true)
        
        vibrateOnMessageSwitch.addTarget(self, action: #selector(vibrateMessageChanged), for: UIControlEvents.valueChanged)
        vibrateOnMessageSwitch.setOn(defaults.bool(forKey: "vibrateOnMessage"), animated: true)
        
        if let emergencyNumber = defaults.string(forKey: "emergencyNumber") {
            emergencyNumberField.text = emergencyNumber
        } else {
            emergencyNumberField.text = "911"
            setPreferenceValue(key: "emergencyNumber", value: "911")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func shakeSwitchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        setPreferenceValue(key: "callOnShake", value: value)
    }
    
    @objc func vibrateCallChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        setPreferenceValue(key: "vibrateOnCall", value: value)
    }
    
    @objc func vibrateMessageChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        setPreferenceValue(key: "vibrateOnMessage", value: value)

    }
    
    //Save Preferences in UserDefaults Storage
    func setPreferenceValue(key: String, value: Any) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    @IBAction func emergencyNumberChanged(_ sender: Any) {
        let value = emergencyNumberField.text;
        setPreferenceValue(key: "emergencyNumber", value: value ?? "911")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}



