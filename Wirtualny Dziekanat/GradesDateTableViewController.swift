//
//  GradesDateTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 26.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class GradesDateTableViewController: UITableViewController {

    
    var dates = ["Termin 1","Termin 2","Termin 3"]
    var date : String!
    var mySubject = ""
    var mySubjectType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "gradesDate")
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
        return dates.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradesDate", for: indexPath)
        cell.textLabel?.text = dates[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        date = dates[indexPath.row]
        performSegue(withIdentifier: "gradesUsers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gradesUsers")
        {
            let destinationVC = segue.destination as! GradesUsersTableViewController
            
            destinationVC.date = date
            destinationVC.mySubject = mySubject
            destinationVC.mySubjectType = mySubjectType
        }
    }

}
