//
//  UsersTypeTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 03.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class UsersTypeTableViewController: UITableViewController {
    
    var account_types = ["Student","Dziekanat","Prowadzący"]
    var type : String!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return account_types.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath)
        
        cell.textLabel?.text = account_types[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        type = account_types[indexPath.row]
        
        performSegue(withIdentifier: "usersList", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "usersList")
        {
            let destinationVC = segue.destination as! AllUsersTableViewController
            
            destinationVC.type = type
        }
    }



}
