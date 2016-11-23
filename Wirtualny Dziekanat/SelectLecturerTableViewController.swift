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
    var lecturerDisplay = ""
    var classesData = [String]()
    var classesDataDisplay = [String]()
    var selectedKey = ""
    var selectedLecturer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        myFunc.displayLecturer{ (name) -> () in
            for item in name
            {
                self.keys.append(item.key)
                self.lecturerDisplay = item.value[0] + " " + item.value[1] + " " + item.value[2]
                self.lecturer.append(self.lecturerDisplay)
                
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

        cell.textLabel?.text = lecturer[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedKey = keys[indexPath.row]
        selectedLecturer = lecturer[indexPath.row]
        classesData.insert(selectedKey, at: 3)
        classesDataDisplay.insert(selectedLecturer, at: 2)
        performSegue(withIdentifier: "addClasses", sender: self)
        
    }

 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addClasses")
        {
            let destinationVC = segue.destination as! AddClassesTypeController
            
            destinationVC.classesData = classesData
            destinationVC.classesDataDisplay = classesDataDisplay

        }

    }
    

}
