//
//  ViewController.swift
//  w6d3-demo
//
//  Created by Roland on 2019-02-13.
//  Copyright © 2019 Game of Apps. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        saveName()
    }
    
    // This should be a unique for indexing into the User Defaults "dictionary"
    let usernameKey = "MyUsername"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadName()
//        createDataModel()
        loadDataModel()
    }

    private func saveName() {
        // Nil coalescing operator, if left side is not nil, use the left side value, if nil, use the right side value
        let username = textField.text ?? "Please enter your name"
        
        // Save username to user defaults
        UserDefaults.standard.set(username, forKey: usernameKey)
    }
    
    private func loadName() {
        // Read username for defaults
        guard let username = UserDefaults.standard.value(forKey: usernameKey) as? String else {
            // We were not able to read or decode the username
            label.text = "I don't know who you are"
            return
        }

        // We've successfully read the username
        label.text = "Hello \(username)"
    }
    
    private func createDataModel() {
        // Get a reference to our app delegate object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to get app delegate")
            assertionFailure("Unable to get app delegate")
            return
        }
        
        // Get the managed object context (my "canvas")
        let context = appDelegate.persistentContainer.viewContext
        
        let bob = Person(context: context)
        bob.name = "Bob"
        bob.age = 25
        
        let rufus = Pet(context: context)
        rufus.name = "Rufus"
        
        // Link the relationship between bob and rufus
        rufus.owner = bob
        bob.pets = [ rufus ]
        
        let zoey = Person(context: context)
        zoey.name = "Zoey"
        zoey.age = 20
        
        // Tell coredata to save now (but if you left this out, it will still try to save it sometime later)
        appDelegate.saveContext()
    }
    
    private func loadDataModel() {
        // Get a reference to our app delegate object -- precondition
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to get app delegate")
            assertionFailure("Unable to get app delegate")
            return
        }
        
        // Get reference to the fetch request object for fetching Person objects
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        
        // This predicate is analogous to the WHERE clause in SQL, in this case we're retrieving all Person objects where name is "Zoey"
//        request.predicate = NSPredicate(format: "ANY name == %@", "Zoey")
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let results = try? context.fetch(request) {
            // Fetch was successful, iterate through array of Persons
            for person in results {
                print("Retrieved \(String(describing: person.name)) who is \(person.age) years old")
                
                // See if person has any pets
                if let pets = person.pets {
                    for pet in pets {
                        guard let pet = pet as? Pet else {
                            assertionFailure("Unexpected non-pet objet found")
                            continue
                        }
                        print("Pet's name is \(String(describing: pet.name))")
                    }
                }
            }
        }
        else {
            print("Unable to retrieve data")
        }
    }
}

