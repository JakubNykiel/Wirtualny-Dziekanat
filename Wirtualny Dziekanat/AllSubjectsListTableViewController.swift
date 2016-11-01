//
//  AllSubjectsListTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 30.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AllSubjectsListTableViewController: UITableViewController,UISearchBarDelegate {
    
    var ref: FIRDatabaseReference!
    var fieldKey = [""]
    var fieldDisplay = [""]
    var myFunc = Functions()
    var subjects = [""]
    var subjectDisplay = [""]
    var searchActive : Bool = false
    var filtered:[String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        searchBar.delegate = self
        
        ref = FIRDatabase.database().reference()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subjects.removeAll()
        fieldKey.removeAll()
        
        myFunc.displayFields{ (name) -> () in
            for item in name
            {
                self.fieldKey.append(item.key)
            }
            self.tableView.reloadData()
        }
        ref.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let fieldID = snap.childSnapshot(forPath: "id_field").value as! String
                    let name = snap.childSnapshot(forPath: "name").value as! String
                    
                    for item in self.fieldKey
                    {
                        if(item == fieldID)
                        {
                            self.subjects.append(name)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = subjects.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filtered.count
        }
        else
        {
            return subjects.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjects", for: indexPath)
        
        if(searchActive)
        {
            cell.textLabel?.text = filtered[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = self.subjects[indexPath.row]
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edytuj") { action, index in
            self.performSegue(withIdentifier: "editField", sender: self)
        }
        
        let remove = UITableViewRowAction(style: .normal, title: "Usuń") { action, index in
            let alert = UIAlertController(title: "Czy jesteś pewien?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Powrót", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Usuń", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
//                self.myFunc.removeField(field: self.fieldKey)
                self.subjects.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        edit.backgroundColor = UIColor.lightGray
        remove.backgroundColor = UIColor.red
        
        return [remove, edit]
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
}