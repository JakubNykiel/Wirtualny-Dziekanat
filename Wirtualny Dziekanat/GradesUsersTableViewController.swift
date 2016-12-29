//
//  GradesUsersTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 25.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class GradesUsersTableViewController: UITableViewController {
    
    var mySubject = ""
    var mySubjectType = ""
    var date = ""
    var ref: FIRDatabaseReference!
    let myFunc = Functions()
    var users = [String]()
    var name = [String]()
    var surname = [String]()
    var numbers = [String]()
    var data = [String:String]()
    var keys = [String]()
    var userResult = 0.0
    var results = [String]()
    var counter = 0
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
    }
    override func viewWillAppear(_ animated: Bool) {
        users.removeAll()
        name.removeAll()
        surname.removeAll()
        numbers.removeAll()
        data.removeAll()
        keys.removeAll()
        results.removeAll()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradesUsers", for: indexPath)
        cell.textLabel?.text = self.numbers[indexPath.row] + ": "  + self.surname[indexPath.row] + " " + self.name[indexPath.row]
        
        cell.imageView?.image = UIImage(named:self.results[indexPath.row])
        
        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        data[keys[indexPath.row]] = self.numbers[indexPath.row] + ": " + self.surname[indexPath.row] + " " + self.name[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if(cell.accessoryType == .checkmark)
            {
                cell.accessoryType = .none
                data.removeValue(forKey: keys[indexPath.row])
            }
            else
            {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gradeData")
        {
            let destinationVC = segue.destination as! AddGradeViewController
            
            destinationVC.mySubjectType = mySubjectType
            destinationVC.myDate = date
            destinationVC.mySubject = mySubject
            destinationVC.userData = data
        }
        
    }
    
    func insertElementAtIndex(element: String?, index: Int) {
        
        while results.count < index + 1 {
            results.append("Pusto.png")
        }
        
        results.insert(element!, at: index)
        
        self.tableView.reloadData()
    }
    
    func imageGrade(userResult: Double, index: Int)
    {
        if(userResult == 2.0)
        {
            self.insertElementAtIndex(element: "20.png", index: index)
        }
        else if(userResult == 3.0)
        {
            self.insertElementAtIndex(element: "30.png", index: index)
        }
        else if(userResult == 3.5)
        {
            self.insertElementAtIndex(element: "35.png", index: index)
        }
        else if(userResult == 4.0)
        {
            self.insertElementAtIndex(element: "40.png", index: index)
        }
        else if(userResult == 4.5)
        {
            self.insertElementAtIndex(element: "45.png", index: index)
        }
        else if(userResult == 5.0)
        {
            self.insertElementAtIndex(element: "50.png", index: index)
        }
        else
        {
            self.insertElementAtIndex(element: "Pusto.png", index: index)
        }
    }
    
    func loadData()
    {
        ref.child("subject-classes").child(mySubject).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let subjectUsers = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.counter = subjectUsers.count
                for (index, subjectUser) in subjectUsers.enumerated()
                {
                    let myRef = self.ref.child("users").child(subjectUser.key)
                    myRef.observeSingleEvent(of: .value, with: { (userInfo) in
                        let nam = userInfo.childSnapshot(forPath: "name").value as! String
                        let sur = userInfo.childSnapshot(forPath: "surname").value as! String
                        let num = userInfo.childSnapshot(forPath: "number").value as! String
                        self.name.append(nam)
                        self.surname.append(sur)
                        self.numbers.append(num)
                        self.keys.append(userInfo.key)
                        if(userInfo.hasChild("grades"))
                        {
                            myRef.child("grades").observeSingleEvent(of: .value, with: { (userGrades) in
                                if let grades = userGrades.children.allObjects as? [FIRDataSnapshot] {
                                    for grade in grades
                                    {
                                        let gradeRef = self.ref.child("grades").child(grade.key)
                                        gradeRef.observeSingleEvent(of: .value, with: { (gradeInfo) in
                                            if(gradeInfo.hasChild("dates"))
                                            {
                                                let idClasses = gradeInfo.childSnapshot(forPath: "id_classes").value as! String
                                                if(idClasses == self.mySubject)
                                                {
                                                    gradeRef.child("dates").child("1").observeSingleEvent(of: .value, with: { (result) in
                                                        
                                                        self.userResult = result.value as! Double
                                                        self.imageGrade(userResult: self.userResult, index: index)
                                                    })
                                                    if(self.userResult < 3)
                                                    {
                                                        if(self.date == "Termin 2")
                                                        {
                                                            gradeRef.child("dates").child("2").observeSingleEvent(of: .value, with: { (result) in
                                                                
                                                                self.userResult = result.value as! Double
                                                                self.imageGrade(userResult: self.userResult, index: index)
                                                            })
                                                        }
                                                        if(self.userResult < 3)
                                                        {
                                                            if(self.date == "Termin 3")
                                                            {
                                                                gradeRef.child("dates").child("3").observeSingleEvent(of: .value, with: { (result) in
                                                                    
                                                                    self.userResult = result.value as! Double
                                                                    self.imageGrade(userResult: self.userResult, index: index)
                                                                })
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        })
                                    }
                                }
                            })
                        }
                        else
                        {
                            self.insertElementAtIndex(element: "Pusto.png", index: index)
                        }
                        
                    })
                }
            }
            
        })

    }
    
}
