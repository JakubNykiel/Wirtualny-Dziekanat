//
//  GradesFieldsTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 30.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class GradesFieldsTableViewController: UITableViewController {
    
    var keys = [String]()
    var field = [String]()
    var myFunc = Functions()
    var fieldKey = ""
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keys.removeAll()
        field.removeAll()
        
        myFunc.displayFields{ (name) -> () in
            for item in name
            {
                self.keys.append(item.key)
                self.field.append(item.value)
            }
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return field.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeField", for: indexPath)
        
        cell.textLabel?.text = self.field[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fieldKey = keys[indexPath.row]
        performSegue(withIdentifier: "gradeToSubject", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gradeToSubject")
        {
            let destinationVC = segue.destination as! GradesSubjectTableViewController
            
            destinationVC.fieldKey = fieldKey
            
        }
        
    }
}
