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
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContactsFromStore()
   
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("peoples: \(people.count)")
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")! //1.
        let text = people[indexPath.row].value(forKey: "name") as! String //2.
        cell.textLabel?.text = text //3.
        return cell //4.
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
            
        if(userPhoneNumbers.isEmpty) {
           // TODO show alert dialog
            return
        }
        
      let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        
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
        if(!contactExists(telephone: firstPhoneNumber.stringValue)){
            let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
            // 3
            person.setValue(userName, forKeyPath: "name")
            person.setValue(firstPhoneNumber.stringValue, forKey: "telephoneNumber")
        
            // 4
            do {
                try managedContext.save()
                people.append(person)
                self.tableView.reloadData()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
    func getContactsFromStore() {
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
            people = result
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    func contactExists(telephone: String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmergencyContact")
        fetchRequest.predicate = NSPredicate(format: "telephoneNumber == %@", telephone)
        fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        print("Exists? \(entitiesCount)")
        return entitiesCount > 0
    }
}

