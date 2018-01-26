/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    A view controller that lets the user call the police with the tap of one button.
 */

import UIKit
import AudioToolbox
import CoreMotion
import UserNotifications
import CoreData

class CallViewController: UIViewController, UNUserNotificationCenterDelegate {
  
    
    @IBOutlet weak var CallButton: UIButton!
    
    var counter = 0
    var timer : Timer?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        checkIfContactsSet()
        // add click target to call button
        CallButton.addTarget(self, action: #selector(self.callButtonClicked), for: .touchUpInside)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Overwritten method to allow display IN-App Notification Display
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    //ONClick Handler for Button
    @objc private func callButtonClicked() {
        if(defaults.bool(forKey: "vibrateOnCall")){
            vibrate()
        }
        //Fancy Animation
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.autoreverse],
                       animations: {
                        UIView.setAnimationRepeatCount(4)
                        self.CallButton.transform = CGAffineTransform(scaleX: 0.45, y: 0.45)
                        self.CallButton.backgroundColor = UIColor.red
                       },
                       completion: { _ in
                        self.CallButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.CallButton.backgroundColor = UIColor(red: 192.0 / 255.0, green: 57.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
                        }
        )
        //Using telephone URL-Scheme to access phone app
        let emergencyNumber = defaults.string(forKey: "emergencyNumber")!;
        if let phoneCallUrl = URL(string: "tel://\(emergencyNumber)") {
            let application:UIApplication = UIApplication.shared
            if(application.canOpenURL(phoneCallUrl)){
                application.open(phoneCallUrl, completionHandler: nil)
            }
        }
    }
    
    //Vibration
    func vibrate() {
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.vibratePhone), userInfo: nil, repeats: true)
    }
    
    //Custom Pattern for vibration
    @objc private func vibratePhone() {
        counter+=1
        switch counter {
            case 1,2,3,4,5:
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            default:
            timer?.invalidate()
            }
    }
    
    // Motion detection: Shake
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake && defaults.bool(forKey: "callOnShake") {
            // vibrate once on shake
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            //TODO call emergency call method
        }
    }

    //Check if any Contacts are stored, if not, send notification
    func checkIfContactsSet() {
        let people = getContactsFromStore()
        if(people.count < 1) {
            sendLocalNotif()
        }
    }
    // Check/Request User to allow notifications
    func initNotifSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]){ (success, error) in
            if (success) {
                self.checkIfContactsSet()
            } else {
                print("User does not want notifications")
            }
        }
    }
    
    //Get stored Emergency Contacts
    func getContactsFromStore() -> [NSManagedObject] {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EmergencyContact", in: managedContext)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        // Load from storage
        var result: [EmergencyContact] = []
        do {
            result = try managedContext.fetch(fetchRequest) as! [EmergencyContact]
            // fill list with result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return result
    }
    
    //Build and Send notification
    func sendLocalNotif() {
        let notification = UNMutableNotificationContent()
        notification.title = "No Emergency Contacts set"
        notification.body = "Please check your settings and choose your Emergency Contacts!"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "NoSettingNotif", content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
}

