//
//  SelectFieldTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 18.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class SelectFieldTableViewController: UITableViewController {
    
    var tableResult:[String] = [""]
    var keyResult:[String] = [""]
    var selectedCell = ""
    var selectedKey = ""
    var ref: FIRDatabaseReference!
    var field = [String]()
    var keys = [String]()
    var chooseField = false
    var chooseClasses = false
    let myFunc = Functions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        ref = FIRDatabase.database().reference()
        
        myFunc.displayFields{ (name) -> () in
            for item in name
            {
                self.keys.append(item.key)
                self.field.append(item.value)
            }
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return field.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath)
        
        cell.textLabel?.text = self.field[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        selectedKey = keys[indexPath.row]
        tableResult.insert(selectedCell, at: 1)
        keyResult.insert(selectedKey, at: 1)
        performSegue(withIdentifier: "fieldToSemester", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fieldToSemester")
        {
            let destinationVC = segue.destination as! SelectSemesterTableViewController
            
            destinationVC.tableResult = tableResult
            destinationVC.keyResult = keyResult
            destinationVC.chooseField = chooseField
            destinationVC.chooseClasses = chooseClasses
        }
    }
}
