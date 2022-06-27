//
//  ViewController.swift
//  HitListFromRay
//
//  Created by Mahmoud on 6/27/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    //MARK:- Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // It now holds instances of NSManagedObject rather than simple strings
    var people: [NSManagedObject] = []
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    //MARK:- Actions
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        // Alert
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        alert.addTextField { (text) in
            text.placeholder = "Write a name"
        }
        // Alert Actions
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] (action) in
            if let textField = alert.textFields?.first?.text {
                self.save(name: textField)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    // Methods
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        //3
        
        person.setValue(name, forKeyPath: "name")
        
        do{
            try managedContext.save()
            people.append(person)
        }catch let error as NSError {
            print("Couldn't save the data \(error)")
        }
    }
    
    func fetch() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        //1
        let managedContext  = appDelegate.persistentContainer.viewContext

        //2
        let fetchRequest    = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
          people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
}

//MARK:- TableView Delegate & DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let persons = people[indexPath.row]
        
        cell.textLabel?.text = persons.value(forKeyPath: "name") as? String
        
        return cell
    }
}
 

/*
 << Important NOTES >>
 
 NSManagedObject doesn’t know about the name attribute you defined in your Data Model, so there’s no way of accessing it directly with a property. The only way Core Data provides to read the value is key-value coding, commonly referred to as KVC
 
 */
