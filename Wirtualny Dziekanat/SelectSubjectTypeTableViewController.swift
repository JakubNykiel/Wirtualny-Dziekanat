//
//  DziekanatAddSubjectTypeTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 23.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class SelectSubjectTypeTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var subjectType = [FIRDataSnapshot]()
    let cellReuseIdentifier = "subjectTypeCell"
    var selectedCell = ""
    var selectedKey = ""
    var keys = [String]()
    var classesData = [String]()
    var classesDataDisplay = [String]()
    var selectedType = ""
    var selectedTypeToDisplay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
        ref.child("subject-type").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    self.keys.append(snap.key)
                    let sn = snap.childSnapshot(forPath: "name")
                    self.subjectType.append(sn)
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
        // #warning Incomplete implementation, return the number of rows
        return subjectType.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        cell.textLabel?.text = self.subjectType[indexPath.row].value as? String
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedType = keys[indexPath.row]
        selectedTypeToDisplay = self.subjectType[indexPath.row].value as! String
        classesData.insert(selectedType, at: 2)
        classesDataDisplay.insert(selectedTypeToDisplay, at: 1)
        performSegue(withIdentifier: "showListWithLecturer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showListWithLecturer")
        {
            let destinationVC = segue.destination as! SelectLecturerTableViewController
            
            destinationVC.classesData = classesData
            destinationVC.classesDataDisplay = classesDataDisplay
        }
        
    }
    

}
