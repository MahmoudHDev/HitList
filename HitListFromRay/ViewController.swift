//
//  ViewController.swift
//  HitListFromRay
//
//  Created by Mahmoud on 6/27/22.
//

import UIKit

class ViewController: UIViewController {
    //MARK:- Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myLabel : UILabel!
    var arrName: [String] = []
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                // Do Something
                self.arrName.append(textField)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
}

//MARK:- TableView Delegate & DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrName[indexPath.row]
        
        return cell
    }
}
