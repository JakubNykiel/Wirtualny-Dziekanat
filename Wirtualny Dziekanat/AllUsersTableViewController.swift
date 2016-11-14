//
//  AllUsersTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 03.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
class AllUsersTableViewController: UITableViewController {
    
    var type = ""
    var ref: FIRDatabaseReference!
    var users = [String]()
    var name = [String]()
    var surname = [String]()
    var numbers = [String]()
    var semester = [String]()
    var titleLecturer = [String]()
    let myFunc = Functions()
    var userId = [String]()
    var currentUserId = ""
    var faculty = ""
    var uid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users.removeAll()
        name.removeAll()
        surname.removeAll()
        numbers.removeAll()
        semester.removeAll()
        titleLecturer.removeAll()
        userId.removeAll()
        loadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return name.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        if(type == "Student")
        {
            cell.textLabel?.text = name[indexPath.row] + " " + surname[indexPath.row] + " / " + numbers[indexPath.row]
        }
        else if(type == "Prowadzący")
        {
            cell.textLabel?.text = titleLecturer[indexPath.row] + " " + name[indexPath.row] + " " + surname[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = name[indexPath.row] + " " + surname[indexPath.row]

        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        currentUserId = userId[indexPath.row]
        let edit = UITableViewRowAction(style: .normal, title: "Edytuj") { action, index in
            if(self.type == "Student")
            {
                self.performSegue(withIdentifier: "editStudent", sender: self)

            }
            else if(self.type == "Prowadzący")
            {
                self.performSegue(withIdentifier: "editLecturer", sender: self)
            }
            else
            {
                self.performSegue(withIdentifier: "editDeanery", sender: self)
                
            }

        }
        
        let remove = UITableViewRowAction(style: .normal, title: "Usuń") { action, index in
            let alert = UIAlertController(title: "Czy jesteś pewien?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Powrót", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Usuń", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
                
                if(self.type == "Student")
                {
                    self.myFunc.removeStudent(user: self.currentUserId)
                    self.semester.remove(at: indexPath.row)
                    self.numbers.remove(at: indexPath.row)
                }
                else if(self.type == "Prowadzący")
                {
                    self.myFunc.removeClasses(classes: self.currentUserId)
                    self.titleLecturer.remove(at: indexPath.row)
                }
                else
                {
                    self.myFunc.removeDeanery(user: self.currentUserId)
                    
                }
                self.name.remove(at: indexPath.row)
                self.surname.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
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
    
    /******************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editStudent")
        {
            let destinationVC = segue.destination as! EditStudentViewController
            
            destinationVC.userKey = self.currentUserId
        }
        if (segue.identifier == "editDeanery")
        {
            let destinationVC = segue.destination as! EditDeaneryViewController
            
            destinationVC.userKey = self.currentUserId
        }
        if (segue.identifier == "editLecturer")
        {
            let destinationVC = segue.destination as! EditLecturerViewController
            
            destinationVC.userKey = self.currentUserId
        }
    }
    
    func loadData()
    {
        uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        ref.child("user-faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    let id_user = snap.childSnapshot(forPath: "id_user").value as! String
                    let id_faculty = snap.childSnapshot(forPath: "id_faculty").value as! String
                    
                    if(self.uid == id_user)
                    {
                        self.faculty = id_faculty
                    }
                }
                
                for snap in snapshots
                {
                    let id_user = snap.childSnapshot(forPath: "id_user").value as! String
                    let id_faculty = snap.childSnapshot(forPath: "id_faculty").value as! String
                    if(self.faculty == id_faculty)
                    {
                        self.users.append(id_user)
                    }
                }
            }
        })
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    if(self.users.contains(snap.key))
                    {
                        let nam = snap.childSnapshot(forPath: "name").value as! String
                        let sur = snap.childSnapshot(forPath: "surname").value as! String
                        let acc = snap.childSnapshot(forPath: "account_type").value as! String
                        
                        
                        if(self.type == "Student" && acc == "Student")
                        {
                            let num = snap.childSnapshot(forPath: "number").value as! String
                            let sem = snap.childSnapshot(forPath: "semester").value as! String
                            self.name.append(nam)
                            self.surname.append(sur)
                            self.numbers.append(num)
                            self.semester.append(sem)
                            self.userId.append(snap.key)
                            
                        }
                        else if(self.type == "Prowadzący" && acc == "Prowadzący")
                        {
                            let title = snap.childSnapshot(forPath: "title").value as! String
                            self.name.append(nam)
                            self.surname.append(sur)
                            self.titleLecturer.append(title)
                            self.userId.append(snap.key)
                        }
                        else if(acc == "Dziekanat" && self.type == "Dziekanat")
                        {
                            self.name.append(nam)
                            self.surname.append(sur)
                            self.userId.append(snap.key)
                        }
                        
                    }
                }
            }
            self.tableView.reloadData()
        })

    }
}
