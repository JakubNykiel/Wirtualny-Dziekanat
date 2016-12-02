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
    var myField = ""
    var myType = ""
    var myFunc = Functions()
    
    override func viewDidLoad() {
        myFunc.show()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        
        ref.child("semester").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSemester", for: indexPath)
        
        cell.textLabel?.text = self.semester[indexPath.row].value as? String
        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                    self.ref.child("user-field").queryOrdered(byChild: "id_field").queryEqual(toValue: self.myField).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            counter = snapshots.count
                            for snap in snapshots
                            {
                                let user = snap.childSnapshot(forPath: "id_user").value as! String
                                
                                self.ref.child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                                    let email = snapshot.childSnapshot(forPath: "email").value as! String
                                    let acc_type = snapshot.childSnapshot(forPath: "account_type").value as! String
                                    if(acc_type == self.myType)
                                    {
                                        let userSemester = snapshot.childSnapshot(forPath: "semester").value as! String
                                        if(current_semester == userSemester )
                                        {
                                            self.emails.append(email)
                                        }
                                    }
                                    number = number + 1
                                    if(number == counter)
                                    {
                                        indicator.stopAnimating()
                                        cell.accessoryView = nil
                                        cell.accessoryType = .checkmark
                                    }
                                })
                                
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
    
    
    
}
