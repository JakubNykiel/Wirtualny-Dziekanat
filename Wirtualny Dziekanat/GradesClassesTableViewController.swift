//
//  GradesClassesTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 24.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class GradesClassesTableViewController: UITableViewController {
    
    var mySubject = ""
    var mySubjectType = ""
    var classes = [String]()
    var classesKey = [String]()
    var keys = [String]()
    var ref: FIRDatabaseReference!
    let myFunc = Functions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for item in snapshots
                {
                    let idSub = item.childSnapshot(forPath: "id_subject").value as! String
                    if(idSub == self.mySubject)
                    {
                        let type = item.childSnapshot(forPath: "id_type").value as! String
                        self.ref.child("subject-type").child(type).observeSingleEvent(of: .value, with: { (subType) in
                            let name = subType.childSnapshot(forPath: "name").value as! String
                            self.classes.append(name)
                            self.keys.append(subType.key)
                            self.classesKey.append(item.key)
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradesClasses", for: indexPath)
        
        cell.textLabel?.text = self.classes[indexPath.row]
        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mySubjectType = self.keys[indexPath.row]
        mySubject = self.classesKey[indexPath.row]
        performSegue(withIdentifier: "gradesDate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gradesDate")
        {
            let destinationVC = segue.destination as! GradesDateTableViewController
            
            destinationVC.mySubject = mySubject
            destinationVC.mySubjectType = mySubjectType
        }
    }
    
    
}
