//
//  MessageAccountTypyTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 20.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class MessageAccountTypyTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate{
    
    var ref: FIRDatabaseReference!
    var account_types = ["Student","Dziekanat","Prowadzący"]
    var emails = [String]()
    var type : String!
    var uid: String!
    var faculty: String!
    var myFunc = Functions()
    var myType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "selectAccountMessage")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        ref = FIRDatabase.database().reference()
        
        uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.myType = snapshot.childSnapshot(forPath: "account_type").value as! String
        })
        myFunc.displayFaculty{ (name) -> () in
            for item in name
            {
                self.faculty = item.key
            }
            
        }
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MessageAccountTypyTableViewController.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.7
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return account_types.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectAccountMessage", for: indexPath)
        cell.textLabel?.text = account_types[indexPath.row]
        cell.accessoryType = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        type = account_types[indexPath.row]
        
        performSegue(withIdentifier: "FieldMessage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FieldMessage")
        {
            let destinationVC = segue.destination as! MessageFieldTableViewController
            
            destinationVC.type = type
            destinationVC.myType = myType
        }

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
        
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.began) {
            if let cell = tableView.cellForRow(at: indexPath!)
            {
                if cell.accessoryType == .checkmark
                {
                    cell.accessoryType = .none
                }
                else
                {
                    self.ref.child("user-faculty").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for snap in snapshots
                            {
                                let user = snap.childSnapshot(forPath: "id_user").value as! String
                                let facultyID = snap.childSnapshot(forPath: "id_faculty").value as! String
                                
                                if(facultyID == self.faculty)
                                {
                                    self.ref.child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                                        let email = snapshot.childSnapshot(forPath: "email").value as! String
                                        let acc_type = snapshot.childSnapshot(forPath: "account_type").value as! String
                                        if(acc_type == self.account_types[(indexPath?.row)!])
                                        {
                                            self.emails.append(email)
                                        }
                                    })
                                    
                                }
                            }
                        }
                    })
                    cell.accessoryType = .checkmark
                }
            }
        }
        
    }
}
