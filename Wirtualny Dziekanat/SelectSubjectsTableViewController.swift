//
//  SelectSubjectsTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 25.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
class SelectSubjectsTableViewController: UITableViewController {

    var tableResult = [String]()
    var keyResult = [String]()
    var classesData = [String]()
    var ref: FIRDatabaseReference!
    var key:String!
    var subjects = [String]()
    var subjectsKeys = [String]()
    var selectedKey = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
        ref.child("fields").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    let name = snap.childSnapshot(forPath: "name").value as! String
                    let semester = snap.childSnapshot(forPath: "id_faculty").value as! String
                    
                    if( (name == self.tableResult[1]) && (semester == self.tableResult[2]) )
                    {
                        self.key = snap.key
                    }
                }
            }
        })
        ref.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    let field = snap.childSnapshot(forPath: "id_field").value as! String
                    let name = snap.childSnapshot(forPath: "name").value as! String
                    
                    if( field == self.key )
                    {
                        self.subjects.append(name)
                        self.subjectsKeys.append(snap.key)
                    }
                }
            }
            self.tableView.reloadData()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjects", for: indexPath)

        cell.textLabel?.text = self.subjects[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedKey = subjectsKeys[indexPath.row]
        classesData.insert(selectedKey, at: 0)
        performSegue(withIdentifier: "toClasses", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toClasses")
        {
            let destinationVC = segue.destination as! SelectSubjectTypeTableViewController
            
            destinationVC.classesData = classesData
        }

    }
 

}
