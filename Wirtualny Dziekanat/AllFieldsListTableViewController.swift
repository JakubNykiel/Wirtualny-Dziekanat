//
//  AllFieldsListTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 26.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AllFieldsListTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var field = [String]()
    var keys = [String]()
    var myFunc = Functions()
    
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return field.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fields", for: indexPath)
        
        cell.textLabel?.text = self.field[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edytuj") { action, index in
            self.performSegue(withIdentifier: "editField", sender: self)
        }
        let remove = UITableViewRowAction(style: .normal, title: "Usuń") { action, index in
            self.performSegue(withIdentifier: "editField", sender: self)
        }
        edit.backgroundColor = UIColor.lightGray
        remove.backgroundColor = UIColor.red
        
        return [remove, edit]
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }

 
}
