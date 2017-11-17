//
//  ViewController.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 07/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import UIKit
import CoreData
import ContactsUI

class SettingsViewController: UITableViewController, CNContactPickerDelegate {
    
    
    @IBOutlet weak var addContact: UIButton!
    @IBOutlet weak var getContacts: UIButton!
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Button tapped")
       
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
        
        
        
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        
        // user name
        let userName:String = contact.givenName + " " + contact.familyName
        // user phone number
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        // user phone number string
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "EmergencyContact",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(userName, forKeyPath: "name")
        person.setValue(firstPhoneNumber.stringValue, forKey: "telephoneNumber")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
    @IBAction func getbuttonTapped(_ sender: UIButton) {
        print(" getButton tapped")
       guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EmergencyContact", in: managedContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [EmergencyContact]
            for contact in result {
                print(contact.name!)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

        
    }
}

