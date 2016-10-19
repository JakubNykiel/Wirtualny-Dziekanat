//
//  SelectSemesterTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 18.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class SelectSemesterTableViewController: UITableViewController {
    
    var tableResult:[String] = [""]
    var keyResult:[String] = [""]
    var selectedCell = ""
    var selectedKey = ""
    var ref: FIRDatabaseReference!
    var semester = [FIRDataSnapshot]()
    var keys = [String]()
    var chooseField = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
        ref.child("semester").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    
                    let sn = snap.childSnapshot(forPath: "name")
                    self.keys.append(snap.key)
                    self.semester.append(sn)
                    
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semester.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "semesterCell", for: indexPath)
        
        cell.textLabel?.text = self.semester[indexPath.row].value as? String
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        selectedKey = keys[indexPath.row]
        tableResult.insert(selectedCell, at: 2)
        keyResult.insert(selectedKey, at: 2)
        if(chooseField == true)
        {
            performSegue(withIdentifier: "subject", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "semesterToResult", sender: self)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "semesterToResult")
        {
            let destinationVC = segue.destination as! AddStudentController
            
            destinationVC.tableResult = tableResult
            destinationVC.keyResult = keyResult
            
        }
    }

    
    
    
}
