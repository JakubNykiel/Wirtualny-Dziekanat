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
    var userResult:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        ref.child("subject-classes").child(mySubject).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let subjectUsers = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for subjectUser in subjectUsers
                {
                    let myRef = self.ref.child("users").child(subjectUser.key)
                    myRef.observeSingleEvent(of: .value, with: { (userInfo) in
                        let nam = userInfo.childSnapshot(forPath: "name").value as! String
                        let sur = userInfo.childSnapshot(forPath: "surname").value as! String
                        let num = userInfo.childSnapshot(forPath: "number").value as! String
                        self.name.append(nam)
                        self.surname.append(sur)
                        self.numbers.append(num)
                        
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
                                                        self.tableView.reloadData()
                                                    })
                                                    if(self.userResult < 3)
                                                    {
                                                        if(self.date == "Termin 2")
                                                        {
                                                            gradeRef.child("dates").child("2").observeSingleEvent(of: .value, with: { (result) in
                                                                
                                                                self.userResult = result.value as! Double
                                                                self.tableView.reloadData()
                                                            })
                                                        }
                                                        if(self.userResult < 3)
                                                        {
                                                            if(self.date == "Termin 3")
                                                            {
                                                                gradeRef.child("dates").child("3").observeSingleEvent(of: .value, with: { (result) in
                                                                    
                                                                    self.userResult = result.value as! Double
                                                                    self.tableView.reloadData()
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
                        self.tableView.reloadData()
                    })
                }
            }
            
        })
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
        
        cell.textLabel?.text = self.numbers[indexPath.row] + " | " + self.name[indexPath.row] + self.surname[indexPath.row]
        cell.imageView?.image = UIImage(named: "Pusto.png")
        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
}
