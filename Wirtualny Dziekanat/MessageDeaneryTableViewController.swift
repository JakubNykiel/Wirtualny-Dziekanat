//
//  MessageUsersTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 29.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class MessageDeaneryTableViewController: UITableViewController, UISearchBarDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var ref: FIRDatabaseReference!
    var users = [String]()
    var name = [String]()
    var surname = [String]()
    let myFunc = Functions()
    var userId = [String]()
    var currentUserId = ""
    var faculty = ""
    var uid = ""
    var emails = [String]()
    var data = [String:String]()
    var userKey = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filteredKey = [String]()
    var filteredValue = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        searchBar.delegate = self
        ref = FIRDatabase.database().reference()
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MessageAccountTypyTableViewController.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.7
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users.removeAll()
        name.removeAll()
        surname.removeAll()
        userId.removeAll()
        loadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredKey.removeAll()
        filteredValue.removeAll()
        let filtered = data.filter{
            let string = $1
            if(string.contains(searchText))
            {
                return true
            }
            else
            {
                return false
            }
        }
        
        for result in filtered {
            filteredKey.append(result.key)
            filteredValue.append(result.value)
        }
        if searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filteredValue.count
        }
        else
        {
            return name.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deaneryMessage", for: indexPath)
        
        let cellUserId = userId[indexPath.row]
        if(searchActive)
        {
            cell.textLabel?.text = filteredValue[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = self.data[cellUserId]
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.accessoryType = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
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
                    if(searchActive) {
                        self.userKey = self.filteredKey[(indexPath?.row)!]
                    }
                    else
                    {
                        self.userKey = self.userId[(indexPath?.row)!]
                    }
                    
                    self.ref.child("users").child(userKey).observeSingleEvent(of: .value, with: { (snapshot) in
                        let email = snapshot.childSnapshot(forPath: "email").value as! String
                        self.emails.append(email)
                    })
                    
                    cell.accessoryType = .checkmark
                }
            }
        }
        
    }
    
    func loadData()
    {
        uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        ref.child("users").child(uid).child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    self.ref.child("faculty").child(snap.key).child("users").observeSingleEvent(of: .value, with: { (userSnap) in
                        if let users = userSnap.children.allObjects as? [FIRDataSnapshot] {
                            for user in users
                            {
                                self.ref.child("users").child(user.key).observeSingleEvent(of: .value, with: { (myUser) in
                                    let nam = myUser.childSnapshot(forPath: "name").value as! String
                                    let sur = myUser.childSnapshot(forPath: "surname").value as! String
                                    let acc = myUser.childSnapshot(forPath: "account_type").value as! String
                                    if(acc == "Dziekanat")
                                    {
                                        self.name.append(nam)
                                        self.surname.append(sur)
                                        self.userId.append(myUser.key)
                                        self.data.updateValue(nam + " " + sur, forKey: myUser.key)
                                    }
                                    self.tableView.reloadData()
                                })
                            }
                        }
                    })
                }
            }
        })
    }
}
