//
//  SelectFacultyTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 28.09.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class SelectFacultyTableViewController: UITableViewController {
    var ref: FIRDatabaseReference!
    var faculty = [FIRDataSnapshot]()
    let cellReuseIdentifier = "facultyCell"
    var selectedCell = ""

    @IBOutlet var facultyView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
        ref.child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            var newItems = [FIRDataSnapshot]()
 
            for item in snapshot.children {
                newItems.append(item as! FIRDataSnapshot)
            }
            self.faculty = newItems
            
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
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        performSegue(withIdentifier: "BackToAddField", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BackToAddField")
        {
            let destinationVC:DziekanatAddFieldController = segue.destination as! DziekanatAddFieldController
            
            destinationVC.tableResult = selectedCell
            
        }
    }
 

}
