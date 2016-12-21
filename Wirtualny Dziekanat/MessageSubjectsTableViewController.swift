//
//  MessageSubjectsTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 21.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class MessageSubjectsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {

    var ref: FIRDatabaseReference!
    let myFunc = Functions()
    var emails = [String]()
    var myField = ""
    var myType = ""
    var fields = [String]()
    var keys = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        myFunc.show()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(uid!).child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSubjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for userSubject in userSubjects
                {
                    self.ref.child("subjects").child(userSubject.key).observeSingleEvent(of: .value, with: { (subject) in
                            let idField = subject.childSnapshot(forPath: "id_field").value as! String
                            if(idField == self.myField)
                            {
                                let name = subject.childSnapshot(forPath: "name").value as! String
                                self.fields.append(name)
                                self.keys.append(subject.key)
                                self.tableView.reloadData()
                            }
                        })
                    }
                }
            })
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MessageAccountTypyTableViewController.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        self.tableView.reloadData()

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
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSubject", for: indexPath)
        
        cell.textLabel?.text = self.fields[indexPath.row]
        cell.accessoryType = .none
        
        return cell
    }
    @IBAction func sendButton(_ sender: Any) {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setToRecipients(emails)
        mailComposerVC.mailComposeDelegate = self
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
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
                    let currentSubject = keys[(indexPath?.row)!]
                    ref.child("subjects").child(currentSubject).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let userSubjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            counter = userSubjects.count
                            for userSubject in userSubjects
                            {
                                self.ref.child("users").child(userSubject.key).observeSingleEvent(of: .value, with: { (userEmail) in
                                    let email = userEmail.childSnapshot(forPath: "email").value as! String
                                    self.emails.append(email)
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



}
