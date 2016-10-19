//
//  SelectFacultyTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 28.09.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase


class SelectFacultyTableViewController: UITableViewController  {
    
    var ref: FIRDatabaseReference!
    var faculty = [FIRDataSnapshot]()
    let cellReuseIdentifier = "facultyCell"
    var selectedCell = ""
    var selectedKey = ""
    var keys = [String]()
    var field:Bool = false
    var type = ""
    
    
    var fieldFaculty: DziekanatAddFieldController!

    @IBOutlet var facultyView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
        
        ref.child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
        
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    self.keys.append(snap.key)
                    let sn = snap.childSnapshot(forPath: "name")
                    self.faculty.append(sn)
                }
            }
            print("Wczytano wydziały!")
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
        return faculty.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
    
        cell.textLabel?.text = self.faculty[indexPath.row].value as? String
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        selectedKey = keys[indexPath.row]
        
        
        if(field == true)
        {
            field = false
            performSegue(withIdentifier: "addFieldSegue", sender: self)
        }
        else if(type == "Dziekanat")
        {
            performSegue(withIdentifier: "sendDataToDeanery", sender: self)
        }
        else if(type == "Student")
        {
            performSegue(withIdentifier: "sendDataToStudent", sender: self)
        }
        else if(type == "Profesor")
        {
            performSegue(withIdentifier: "sendDataToProf", sender: self)
        }
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addFieldSegue")
        {
            let destinationVC = segue.destination as! DziekanatAddFieldController
            
            destinationVC.tableResult = selectedCell
            print(destinationVC.tableResult)
            destinationVC.keyResult = selectedKey
            
        }
        if (segue.identifier == "sendDataToStudent")
        {
            let destinationVC = segue.destination as! SelectFieldTableViewController
            
            destinationVC.tableResult[0] = selectedCell
            destinationVC.keyResult[0] = selectedKey
            
            
        }
        if (segue.identifier == "sendDataToDeanery")
        {
            let destinationVC = segue.destination as! AddDeaneryController
            
            destinationVC.tableResult = selectedCell
            destinationVC.keyResult = selectedKey
            
        }
        if (segue.identifier == "sendDataToProf")
        {
            let destinationVC = segue.destination as! AddLecturerController
            
            destinationVC.tableResult = selectedCell
            destinationVC.keyResult = selectedKey
            
        }
    }
 

}
