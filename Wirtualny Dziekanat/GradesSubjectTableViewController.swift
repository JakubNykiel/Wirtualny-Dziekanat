//
//  GradesSubjectTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 22.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class GradesSubjectTableViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    let myFunc = Functions()
    var accountType = ""
    var subjects = [String]()
    var keys = [String]()
    var mySubject = ""
    var mySubjectName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        loadData(uid: uid!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradesSubject", for: indexPath)
        
        cell.textLabel?.text = self.subjects[indexPath.row]
        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mySubject = self.keys[indexPath.row]
        mySubjectName = self.subjects[indexPath.row]
        performSegue(withIdentifier: "gradesClasses", sender: self)
    }

    
    func loadData(uid: String)
    {
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.accountType = snapshot.childSnapshot(forPath: "account_type").value as! String
        })
        
        if(accountType == "Student")
        {
            
        }
        else
        {
            ref.child("users").child(uid).child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
                if let userSubjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for userSubject in userSubjects
                    {
                        self.ref.child("subjects").child(userSubject.key).observeSingleEvent(of: .value, with: { (subject) in
                            let name = subject.childSnapshot(forPath: "name").value as! String
                            self.keys.append(userSubject.key)
                            self.subjects.append(name)
                            self.tableView.reloadData()
                        })
                    }
                }
            })
        }//koniec else
        
    }//koniec loadData
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gradesClasses")
        {
            let destinationVC = segue.destination as! GradesClassesTableViewController
            destinationVC.mySubject = mySubject
            destinationVC.mySubjectName = mySubjectName
            
        }
    }
}
