//
//  ViewController.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 07/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    
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
        person.setValue("Test", forKeyPath: "name")
        person.setValue("1234", forKey: "telephoneNumber")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
        
        let peopleFetch: NSFetchRequest<EmergencyContact> = EmergencyContact.fetchRequest()
        
        do {
            let fetchedPeople = try managedContext.executeFetchRequest(peopleFetch) as! NSFetchRequest<EmergencyContact>
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }

    }
}

