//
//  MessageFieldTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 22.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class MessageFieldTableViewController: UITableViewController, UISearchBarDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var ref: FIRDatabaseReference!
    var field = [String]()
    var keys = [String]()
    var myFunc = Functions()
    var type: String!
    var data = ["":""]
    var emails = [String]()
    var subjectsKey = [String]()
    var editField = ""
    var fieldKey = ""
    var myType = ""
    var userID = ""
    var lecturerSubjects = [String]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filteredKey = [String]()
    var filteredValue = [String]()
    
    override func viewDidLoad() {
        myFunc.show()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keys.removeAll()
        field.removeAll()
        
        if(self.myType == "Prowadzący")
        {
            myFunc.displayFieldForUid{ (name) -> () in
                for item in name
                {
                    self.keys.append(item.key)
                    self.field.append(item.value)
                    self.data[item.key] = item.value
                }
                self.tableView.reloadData()
            }
        }
        else
        {
            myFunc.displayFields{ (name) -> () in
                for item in name
                {
                    self.keys.append(item.key)
                    self.field.append(item.value)
                    self.data[item.key] = item.value
                }
                self.tableView.reloadData()
            }
        }
        
        myFunc.hide()
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
            return field.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fieldsMessage", for: indexPath)
        
        if(searchActive)
        {
            cell.textLabel?.text = filteredValue[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = self.field[indexPath.row]
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.accessoryType = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(searchActive) {
            self.fieldKey = self.filteredKey[(indexPath.row)]
        }
        else
        {
            self.fieldKey = self.keys[(indexPath.row)]
        }
        
        if(myType == "Prowadzący")
        {
            performSegue(withIdentifier: "MessageFieldToSubject", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "MessageSemester", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
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
            myFunc.show()
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
                    if(searchActive) {
                        self.fieldKey = self.filteredKey[(indexPath?.row)!]
                    }
                    else
                    {
                        self.fieldKey = self.keys[(indexPath?.row)!]
                    }
                    let indicator = cell.accessoryView as! UIActivityIndicatorView
                    indicator.startAnimating()
                    ref.child("fields").child(self.fieldKey).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let users = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            counter = users.count
                            for user in users
                            {
                                self.ref.child("users").child(user.key).observeSingleEvent(of: .value, with: { (userSnap) in
                                    let email = userSnap.childSnapshot(forPath: "email").value as! String
                                    let acc_type = userSnap.childSnapshot(forPath: "account_type").value as! String
                                    if(acc_type == self.type)
                                    {
                                        self.emails.append(email)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MessageSemester")
        {
            let destinationVC = segue.destination as! MessageSemesterTableViewController
            
            destinationVC.myField = fieldKey
            destinationVC.myType = type
        }
        if (segue.identifier == "MessageFieldToSubject")
        {
            let destinationVC = segue.destination as! MessageSubjectsTableViewController
            
            destinationVC.myField = fieldKey
            destinationVC.myType = myType
        }
    }
}
