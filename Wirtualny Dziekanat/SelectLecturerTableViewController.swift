//
//  SelectLecturerTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 24.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class SelectLecturerTableViewController: UITableViewController {

    var myFunc = Functions()
    var field = [String]()
    var keys = [String]()
    var lecturer = [String]()
    var lecturer_title = [String]()
    var lecturer_name = [String]()
    var lecturer_surname = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        myFunc.displayLecturer{ (name) -> () in
            for item in name
            {
                self.keys.append(item.key)
                let v1 = item.value[0]
                self.lecturer_title.append(v1)
                self.lecturer_name.append(item.value[1])
                self.lecturer_surname.append(item.value[2])
                
            }
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lecturerCell", for: indexPath)

        cell.textLabel?.text = self.lecturer_title[indexPath.row] + " " + self.lecturer_name[indexPath.row] + " " + self.lecturer_surname[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fieldToSemester")
        {
            let destinationVC = segue.destination as! SelectSemesterTableViewController
            

        }

    }
    

}
