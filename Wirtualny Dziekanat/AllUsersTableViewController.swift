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
    var fields = [String]()
    var fieldName = [String]()
    var titleLecturer = [String]()
    let myFunc = Functions()
    var userId = [String]()
    var currentUserId = ""
    var currentUserFieldId = ""
    var currentUserSemesterId = ""
    var faculty = ""
    var uid = ""
    var keys = [String]()
    var lecturer = [String]()
    var lecturerDisplay = ""
    var cellData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        users.removeAll()
        name.removeAll()
        surname.removeAll()
        numbers.removeAll()
        semester.removeAll()
        fields.removeAll()
        titleLecturer.removeAll()
        userId.removeAll()
        keys.removeAll()
        lecturer.removeAll()
        loadData()
        self.tableView.reloadData()
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
            cell.textLabel?.text = cellData[indexPath.row]
        }
        else if(type == "Prowadzący")
        {
            cell.textLabel?.text = titleLecturer[indexPath.row] + " " + name[indexPath.row] + " " + surname[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = name[indexPath.row] + " " + surname[indexPath.row]
            
        }
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
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
                    self.currentUserFieldId = self.fields[indexPath.row]
                    self.currentUserSemesterId = self.semester[indexPath.row]
                    self.myFunc.removeStudent(user: self.currentUserId, field: self.currentUserFieldId, semester: self.currentUserSemesterId )
                    self.semester.remove(at: indexPath.row)
                    self.numbers.remove(at: indexPath.row)
                }
                else if(self.type == "Prowadzący")
                {
                    self.myFunc.removeLecturer(user: self.currentUserId)
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
            destinationVC.userFieldKey = self.currentUserFieldId
            destinationVC.userSemesterKey = self.currentUserSemesterId
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
        myFunc.show("Wczytywanie")
        
        ref.child("users").child(uid).child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    self.ref.child("users").queryOrdered(byChild: "number").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let users = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for user in users
                            {
                                let myRef = self.ref.child("users").child(user.key)
                                let acc = user.childSnapshot(forPath: "account_type").value as! String
                                
                                if(acc != "agh")
                                {
                                    myRef.child("faculty").observeSingleEvent(of: .value, with: { (facInfo) in
                                        if(facInfo.hasChild(snap.key))
                                        {
                                            myRef.observeSingleEvent(of: .value, with: { (currentUser) in
                                                let nam = currentUser.childSnapshot(forPath: "name").value as! String
                                                let sur = currentUser.childSnapshot(forPath: "surname").value as! String
                                                
                                                
                                                if(self.type == "Student" && acc == "Student")
                                                {
                                                    let num = currentUser.childSnapshot(forPath: "number").value as! String
                                                    myRef.child("fields").observeSingleEvent(of: .value, with: { (snapshot) in
                                                        if let userFields = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                                            for field in userFields
                                                            {
                                                                self.ref.child("fields").child(field.key).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                                                                    self.name.append(nam)
                                                                    self.surname.append(sur)
                                                                    self.numbers.append(num)
                                                                    self.fields.append(field.key)
                                                                    self.semester.append(field.value as! String)
                                                                    self.userId.append(user.key)
                                                                    self.fieldName.append(snapshot.value as! String)
                                                                    let myDataToCell = num + " | " + sur + " " + nam + " | " + (snapshot.value as! String)
                                                                    self.cellData.append(myDataToCell)
                                                                    self.tableView.reloadData()
                                                                })
                                                            }
                                                        }
                                                    })
                                                }
                                                else if(self.type == "Prowadzący" && acc == "Prowadzący")
                                                {
                                                    self.myFunc.displayLecturer{ (name) -> () in
                                                        for item in name
                                                        {
                                                            self.keys.append(item.key)
                                                            self.lecturerDisplay = item.value[0] + " " + item.value[1] + " " + item.value[2]
                                                            self.lecturer.append(self.lecturerDisplay)
                                                        }
                                                        
                                                        self.tableView.reloadData()
                                                    }
                                                }
                                                else if(acc == "Dziekanat" && self.type == "Dziekanat")
                                                {
                                                    self.name.append(nam)
                                                    self.surname.append(sur)
                                                    self.userId.append(user.key)
                                                }
                                                self.tableView.reloadData()
                                                
                                            })
                                        }
                                    })
                                }
                            }
                        }
                        self.myFunc.hide()
                    })
                }
            }
            
        })
    }
    
    
}
