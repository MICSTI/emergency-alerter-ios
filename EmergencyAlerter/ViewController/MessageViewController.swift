/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
 A view controller that lets the user send emergency text messages to preconfigured emergency contacts.
 */


import UIKit
import AudioToolbox
import MessageUI
import CoreData

class MessageViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var MessageButton: UIButton!
    
    var counter = 0
    var timer : Timer?
    let defaults = UserDefaults.standard
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // add click target to call button
        MessageButton.addTarget(self, action: #selector(self.messageButtonClicked), for: .touchUpInside)
        people = getContactsFromStore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func messageButtonClicked() {
        
        if(defaults.bool(forKey: "vibrateOnMessage")){
            vibrate()
        }
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.autoreverse],
                       animations: {
                        UIView.setAnimationRepeatCount(5)
                        
                        self.MessageButton.transform = CGAffineTransform(scaleX: 0.45, y: 0.45)
                        self.MessageButton.backgroundColor = UIColor(red: 249.0 / 255.0, green: 105.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
        },
                       completion: { _ in
                        self.MessageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.MessageButton.backgroundColor = UIColor(red: 211.0 / 255.0, green: 84.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        })
        sendMessage()
        
    }
    func sendMessage(){
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "I need help"
        messageVC.recipients = people.map({(contact: NSManagedObject ) -> String in
            let cnt = contact as! EmergencyContact
            print("\(cnt.telephoneNumber!)")
            return cnt.telephoneNumber!
        })
        messageVC.messageComposeDelegate = self
        present(messageVC, animated: true, completion: nil)
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
        case 1,3,5:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        default:
            timer?.invalidate()
        }
    }
    
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}


