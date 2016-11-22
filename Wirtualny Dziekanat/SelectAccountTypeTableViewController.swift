//
//  SelectAccountTypeTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 03.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class SelectAccountTypeTableViewController: UITableViewController {
   
    @IBOutlet var selectType: UITableView!

    var account_types = ["Student","Dziekanat","Prowadzący"]
    var type : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "selectAccount")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return account_types.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectAccount", for: indexPath)
        cell.textLabel?.text = account_types[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        type = account_types[indexPath.row]
        
        if(type == "Dziekanat")
        {
            performSegue(withIdentifier: "sendTypeSegue", sender: self)
        }
        else if(type == "Prowadzący")
        {
            performSegue(withIdentifier: "goToProf", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "goToStudent", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sendTypeSegue")
        {
            let destinationVC = segue.destination as! SelectFacultyTableViewController
            
            destinationVC.type = type
        }
    }
}
