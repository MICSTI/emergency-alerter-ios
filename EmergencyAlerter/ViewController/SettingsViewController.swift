/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    A view controller that lets the user configure important settings (i.e. emergency contacts).
 */

import UIKit
import CoreData
import ContactsUI

class SettingsViewController: UITableViewController, CNContactPickerDelegate {
    
    @IBOutlet weak var addContact: UIButton!
    
    // Emergency Contacts in List
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fill Emergency Contact list from storage
        getContactsFromStore()
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //For the table -> Number of entries
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    //Table: Content of Cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")! //1.
        let text = people[indexPath.row].value(forKey: "name") as! String //2.
        cell.textLabel?.text = text //3.
        return cell //4.
    }
    
    //Use ContactPicker
    @IBAction func buttonTapped(_ sender: UIButton) {
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
        let managedContext = appDelegate.persistentContainer.viewContext
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "EmergencyContact", in: managedContext)!
        if(!contactExists(telephone: firstPhoneNumber.stringValue)){
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
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
       // Do Nothing on cancel
    }
    
    func getContactsFromStore() {
       guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EmergencyContact", in: managedContext)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        // Load from storage
        do {
            let result = try managedContext.fetch(fetchRequest) as! [EmergencyContact]
            // fill list with result
            people = result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    //Check if contact already exists
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
        return entitiesCount > 0
    }
    
    //Delete from List of emergency contacts
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        if editingStyle == .delete {
            //init fetchrequest load entity based on telephone number
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmergencyContact")
            fetchRequest.predicate = NSPredicate(format: "telephoneNumber == %@", (self.people[indexPath.row].value(forKey: "telephoneNumber") as? String)!)
            fetchRequest.includesSubentities = false
            
            //Delete found entities from storage
            if let result = try? managedContext.fetch(fetchRequest) {
                for object in result {
                    managedContext.delete(object as! NSManagedObject)
                    do {
                        //Commit and remove items from list and view too
                        try managedContext.save()
                        self.people.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
        }
    }
}

