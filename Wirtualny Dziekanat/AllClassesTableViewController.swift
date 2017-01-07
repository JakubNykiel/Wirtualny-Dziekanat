//
//  AllClassesTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 03.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AllClassesTableViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var subjectKey = ""
    var classesKey = ""
    var classes = [String]()
    var classesKeys = [String]()
    var id = [String]()
    var myFunc = Functions()
    var currentClass = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        myFunc.show("Wczytywanie")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
        ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    let idSubject = snap.childSnapshot(forPath: "id_subject").value as! String
                    let id_type = snap.childSnapshot(forPath: "id_type").value as! String
                    
                    if(idSubject == self.subjectKey)
                    {
                        self.id.append(id_type)
                        self.classesKeys.append(snap.key)
                    }
                }
            }
        })
        ref.child("subject-type").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    let name = snap.childSnapshot(forPath: "name").value as! String
    
                    for item in self.id
                    {
                        if(item == snap.key)
                        {
                            self.classes.append(name)
                        }
                    }
                }
            }
            self.tableView.reloadData()
            self.myFunc.hide()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classes", for: indexPath)

        cell.textLabel?.text = self.classes[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        classesKey = classesKeys[indexPath.row]
        currentClass = classes[indexPath.row]
        let remove = UITableViewRowAction(style: .normal, title: "Usuń") { action, index in
            let alert = UIAlertController(title: "Czy jesteś pewien?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Powrót", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Usuń", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
                self.myFunc.removeClasses(classes: self.classesKey)
                self.classes.remove(at: indexPath.row)
                self.classesKeys.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edytuj") { action, index in
            self.performSegue(withIdentifier: "editClasses", sender: self)
        }
        
        edit.backgroundColor = UIColor.gray
        remove.backgroundColor = UIColor.red
        
        return [remove, edit]
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editClasses")
        {
            let destinationVC = segue.destination as! EditClassesViewController
            
            destinationVC.currentClass = currentClass
            destinationVC.classesKey = classesKey
            
        }
    }
 
}
