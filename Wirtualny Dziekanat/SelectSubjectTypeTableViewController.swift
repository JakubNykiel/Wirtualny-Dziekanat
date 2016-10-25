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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        cell.textLabel?.text = self.subjectType[indexPath.row].value as? String
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showListWithLecturer", sender: self)
    }
    

}
