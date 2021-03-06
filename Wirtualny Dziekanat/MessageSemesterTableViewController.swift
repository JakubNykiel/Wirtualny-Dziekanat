//
//  MessageSemesterTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 30.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class MessageSemesterTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate{
    
    var ref: FIRDatabaseReference!
    var semester = [FIRDataSnapshot]()
    var keys = [String]()
    var emails = [String]()
    var users = [String]()
    var myField = ""
    var myType = ""
    var myFunc = Functions()
    var mySem = ""
    
    override func viewDidLoad() {
        myFunc.show()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
        ref.child("semester").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let sn = snap.childSnapshot(forPath: "name")
                    self.keys.append(snap.key)
                    self.semester.append(sn)
                }
            }
            let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MessageAccountTypyTableViewController.handleLongPress(_:)))
            longPressGesture.minimumPressDuration = 0.5
            longPressGesture.delegate = self
            self.tableView.addGestureRecognizer(longPressGesture)
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myFunc.hide()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semester.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSemester", for: indexPath)
        
        cell.textLabel?.text = self.semester[indexPath.row].value as? String
        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mySem = (self.semester[indexPath.row].value as? String)!
        performSegue(withIdentifier: "displayUsersFromSemester", sender: self)
    }
    
    func showSendMailErrorAlert() {
        let errorAlert = UIAlertController(title: "Nie można wysłać maila", message: "Twoje urządzenie nie może wysłać maila. Sprawdź konfiguracje e-mail i spróbuj ponownie.", preferredStyle: UIAlertControllerStyle.alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        emails.removeAll()
    }
    
    func handleLongPress(_ longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        var number = 0
        var counter:Int!
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.began) {
            if let cell = tableView.cellForRow(at: indexPath!)
            {
                if cell.accessoryView == nil {
                    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    cell.accessoryView = indicator
                }
                if cell.accessoryType == .checkmark
                {
                    cell.accessoryType = .none
                }
                else
                {
                    let indicator = cell.accessoryView as! UIActivityIndicatorView
                    indicator.startAnimating()
                    let current_semester = self.semester[(indexPath?.row)!].value as! String
                    
                    ref.child("fields").child(myField).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            counter = snapshots.count
                            for snap in snapshots
                            {
                                
                                self.ref.child("users").child(snap.key).child("fields").observeSingleEvent(of: .value, with: { (fieldSnap) in
                                    if let fields = fieldSnap.children.allObjects as? [FIRDataSnapshot] {
                                        for field in fields
                                        {
                                            if(field.key == self.myField && field.value as! String == current_semester)
                                            {
                                                self.ref.child("users").child(snap.key).observeSingleEvent(of: .value, with: { (userEmail) in
                                                    let email = userEmail.childSnapshot(forPath: "email").value as! String
                                                    self.emails.append(email)
                                                })
                                                
                                            }
                                        }
                                    }
                                })
                                number = number + 1
                                if(number == counter)
                                {
                                    indicator.stopAnimating()
                                    cell.accessoryView = nil
                                    cell.accessoryType = .checkmark
                                }
                                
                            }
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func sendMail(_ sender: Any) {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setToRecipients(emails)
        mailComposerVC.mailComposeDelegate = self
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "displayUsersFromSemester")
        {
            let destinationVC = segue.destination as! MessageStudentTableViewController
            destinationVC.studentSemester = mySem
            destinationVC.myField = myField
        }
        
    }
    
}
