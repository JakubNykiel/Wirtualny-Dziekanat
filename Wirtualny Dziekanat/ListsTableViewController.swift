//
//  ListsTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 26.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {
    
    var lists = ["Lista wszystkich kierunków", "Lista wszystkich przedmiotów", "Lista wszystkich użytkowników", "Lista szczegółowa"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath)
        
        cell.textLabel?.text = self.lists[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "allFields", sender: self)
        case 1:
            performSegue(withIdentifier: "allSubjects", sender: self)
        default:
            print("Error")
        }
    }
}
