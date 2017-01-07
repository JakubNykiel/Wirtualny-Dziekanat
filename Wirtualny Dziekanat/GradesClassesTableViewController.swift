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
    var mySubjectTypeName = ""
    var mySubjectName = ""
    
    var mySubjectTemp = ""
    var mySubjectTypeTemp = ""
    var mySubjectTypeNameTemp = ""
    var mySubjectNameTemp = ""
    
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
    var myDates = [Double]()
    var gradesData = [String:[Double]]()
    var sendGrades = [Double]()
    var data = ""
    var dataArr = [String]()
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
        dataArr.removeAll()
        gradesData.removeAll()
        myDates.removeAll()
        sendGrades.removeAll()
        
        myDates = [0.0,0.0,0.0]
        if(acc == "Student")
        {
            loadDataForStudent()
        }
        else if(acc == "Dziekanat")
        {
            loadDataForDeanery()
        }
        else
        {
            loadData()
        }
        self.tableView.reloadData()
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
        
        mySubjectTypeTemp = self.keys[indexPath.row]
        mySubjectTemp = self.classesKey[indexPath.row]
        mySubjectTypeNameTemp = self.classes[indexPath.row]
        sendGrades = self.gradesData[mySubjectTemp]!
        if(acc == "Student")
        {
            ref.child("subject-classes").child(mySubjectTemp).observeSingleEvent(of: .value, with: { (lecturerDisplay) in
                let lecturer = lecturerDisplay.childSnapshot(forPath: "id_lecturer").value as! String
                self.ref.child("users").child(lecturer).observeSingleEvent(of: .value, with: { (lecturerInfo) in
                    let tit = lecturerInfo.childSnapshot(forPath: "title").value as! String
                    let nam = lecturerInfo.childSnapshot(forPath: "name").value as! String
                    let sur = lecturerInfo.childSnapshot(forPath: "surname").value as! String
                    self.data = tit + " " + nam + " " + sur
                    self.performSegue(withIdentifier: "gradeStudent", sender: self)
                })
                
            })
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
            
            destinationVC.mySubject = mySubjectTemp
            destinationVC.mySubjectType = mySubjectTypeTemp
        }
        else if (segue.identifier == "gradeStudent")
        {
            let destinationVC = segue.destination as! GradesStudentViewController
            
            destinationVC.subjectName = mySubjectName
            destinationVC.typeName = mySubjectTypeNameTemp
            destinationVC.grades = sendGrades
            destinationVC.lecturer = data
        }
    }
    
    func loadDataForDeanery()
    {
        ref.child("subject-classes").observeSingleEvent(of: .value, with: { (subCla) in
            if let snapshots = subCla.children.allObjects as? [FIRDataSnapshot] {
                for item in snapshots
                {
                    let idSub = item.childSnapshot(forPath: "id_subject").value as! String
                    if(idSub == self.mySubject)
                    {
                        let type = item.childSnapshot(forPath: "id_type").value as! String
                        self.ref.child("subject-type").child(type).observeSingleEvent(of: .value, with: { (subType) in
                            let name = subType.childSnapshot(forPath: "name").value as! String
                            self.classes.append(name)
                            self.keys.append(subType.key)
                            self.classesKey.append(item.key)
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        })
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
                    //print("Item.key: " + item.key)
                    self.ref.child("subject-classes").child(item.key).observeSingleEvent(of: .value, with: { (subCla) in
                        let idSub = subCla.childSnapshot(forPath: "id_subject").value as! String
                        //print("idSub: " + idSub + ", mySubject: " + self.mySubject)
                        if(idSub == self.mySubject)
                        {
                            let type = subCla.childSnapshot(forPath: "id_type").value as! String
                            //print("type: " + type)
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
                                                //print("userID: " + userID + ", idClasses: " + idClasses)
                                                self.ref.child("grades").child(grade.key).child("dates").observeSingleEvent(of: .value, with: { (dateInfo) in
                                                    if let dates = dateInfo.children.allObjects as? [FIRDataSnapshot] {
                                                        self.counter = dates.count
                                                        self.i = 0
                                                        for date in dates
                                                        {
                                                            let myGrade = date.value as! Double
                                                            self.myDates.insert(myGrade, at: self.i)
                                                            if(self.userResult < myGrade)
                                                            {
                                                                self.userResult = myGrade
                                                            }
                                                            self.i = self.i + 1
                                                            if(self.i == self.counter)
                                                            {
                                                                self.classes.append(name)
                                                                self.imageGrade(userResult: self.userResult)
                                                                self.gradesData[idClasses] = self.myDates
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
                                                self.gradesData[item.key] = self.myDates
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

