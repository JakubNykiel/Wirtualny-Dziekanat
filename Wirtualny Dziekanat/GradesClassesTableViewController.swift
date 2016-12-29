//
//  GradesClassesTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 24.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class GradesClassesTableViewController: UITableViewController {
    
    var mySubject = ""
    var mySubjectType = ""
    var classes = [String]()
    var classesKey = [String]()
    var keys = [String]()
    var ref: FIRDatabaseReference!
    let myFunc = Functions()
    var acc = ""
    var uid = ""
    var results = [String]()
    var userResult = 0.0
    var counter = 0
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        uid = (FIRAuth.auth()?.currentUser?.uid)!
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.acc = snapshot.childSnapshot(forPath: "account_type").value as! String
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        results.removeAll()
        classes.removeAll()
        classesKey.removeAll()
        keys.removeAll()
        if(acc == "Student")
        {
            loadDataForStudent()
        }
        else
        {
            loadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradesClasses", for: indexPath)
        
        cell.textLabel?.text = self.classes[indexPath.row]
        cell.accessoryType = .none
        if(acc == "Student" && results.count == self.classes.count)
        {
            cell.imageView?.image = UIImage(named:self.results[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mySubjectType = self.keys[indexPath.row]
        mySubject = self.classesKey[indexPath.row]
        if(acc == "Student")
        {
            
        }
        else
        {
            performSegue(withIdentifier: "gradesDate", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gradesDate")
        {
            let destinationVC = segue.destination as! GradesDateTableViewController
            
            destinationVC.mySubject = mySubject
            destinationVC.mySubjectType = mySubjectType
        }
    }
    
    func loadData()
    {
        
        let myRef = ref.child("users").child(uid)
        
        myRef.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for item in snapshots
                {
                    self.ref.child("subject-classes").child(item.key).observeSingleEvent(of: .value, with: { (subCla) in
                        let idSub = subCla.childSnapshot(forPath: "id_subject").value as! String
                        if(idSub == self.mySubject)
                        {
                            let type = subCla.childSnapshot(forPath: "id_type").value as! String
                            self.ref.child("subject-type").child(type).observeSingleEvent(of: .value, with: { (subType) in
                                let name = subType.childSnapshot(forPath: "name").value as! String
                                self.classes.append(name)
                                self.keys.append(subType.key)
                                self.classesKey.append(item.key)
                                self.tableView.reloadData()
                            })
                        }
                    })
                }
            }
        })
    }
    
    func loadDataForStudent()
    {
        let myRef = ref.child("users").child(uid)
        
        myRef.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for item in snapshots
                {
                    self.ref.child("subject-classes").child(item.key).observeSingleEvent(of: .value, with: { (subCla) in
                        let idSub = subCla.childSnapshot(forPath: "id_subject").value as! String
                        if(idSub == self.mySubject)
                        {
                            let type = subCla.childSnapshot(forPath: "id_type").value as! String
                            self.ref.child("subject-type").child(type).observeSingleEvent(of: .value, with: { (subType) in
                                let name = subType.childSnapshot(forPath: "name").value as! String
                                self.ref.child("grades").observeSingleEvent(of: .value, with: { (gradeInfo) in
                                    if let grades = gradeInfo.children.allObjects as? [FIRDataSnapshot] {
                                        for grade in grades
                                        {
                                            let idClasses = grade.childSnapshot(forPath: "id_classes").value as! String
                                            let userID = grade.childSnapshot(forPath: "user").value as! String
                                            if(userID == self.uid && idClasses == item.key)
                                            {
                                                self.ref.child("grades").child(grade.key).child("dates").observeSingleEvent(of: .value, with: { (dateInfo) in
                                                    if let dates = dateInfo.children.allObjects as? [FIRDataSnapshot] {
                                                        self.counter = dates.count
                                                        self.i = 0
                                                        for date in dates
                                                        {
                                                            let myGrade = date.value as! Double
                                                            if(self.userResult < myGrade)
                                                            {
                                                                self.userResult = myGrade
                                                            }
                                                            self.i = self.i + 1
                                                            if(self.i == self.counter)
                                                            {
                                                                self.classes.append(name)
                                                                self.imageGrade(userResult: self.userResult)
                                                                self.keys.append(subType.key)
                                                                self.classesKey.append(item.key)
                                                                self.tableView.reloadData()
                                                            }
                                                        }
                                                    }
                                                })
                                            }
                                            else if(userID == self.uid)
                                            {
                                                self.classes.append(name)
                                                self.keys.append(subType.key)
                                                self.classesKey.append(item.key)
                                                self.results.append("Pusto.png")
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                })
                            })
                        }
                    })
                }
            }
        })
    }
    func imageGrade(userResult: Double)
    {
        if(userResult == 2.0)
        {
            self.results.append("20.png")
        }
        else if(userResult == 3.0)
        {
            self.results.append("30.png")
        }
        else if(userResult == 3.5)
        {
            self.results.append("35.png")
        }
        else if(userResult == 4.0)
        {
            self.results.append("40.png")
        }
        else if(userResult == 4.5)
        {
            self.results.append("45.png")
        }
        else if(userResult == 5.0)
        {
            self.results.append("50.png")
        }
        else
        {
            self.results.append("Pusto.png")
        }
    }
    
}

