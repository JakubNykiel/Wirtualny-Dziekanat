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
    var fieldKey = [String]()
    var keys = [String]()
    
    var editSubject = ""
    var subjectKey = ""
    var fieldDisplay = [String]()
    var myFunc = Functions()
    var subjects = [String]()
    var subjectDisplay = [String]()
    var searchActive : Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredKey = [String]()
    var filteredValue = [String]()
    var data = ["":""]
    
    override func viewDidLoad() {
        myFunc.show("Wczytywanie")
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = true
        searchBar.delegate = self
        
        ref = FIRDatabase.database().reference()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        subjects.removeAll()
        fieldKey.removeAll()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return subjects.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjects", for: indexPath)
        
        if(searchActive)
        {
            cell.textLabel?.text = filteredValue[indexPath.row]
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
        
        if(searchActive)
        {
            subjectKey = self.filteredKey[indexPath.row]
            editSubject = self.filteredValue[indexPath.row]
        }
        else
        {
            subjectKey = self.keys[indexPath.row]
            editSubject = self.subjects[indexPath.row]
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edytuj") { action, index in
            self.performSegue(withIdentifier: "editSubject", sender: self)
        }
        
//        let remove = UITableViewRowAction(style: .normal, title: "Usuń") { action, index in
//            let alert = UIAlertController(title: "Czy jesteś pewien?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Powrót", style: UIAlertActionStyle.default, handler: nil))
//            alert.addAction(UIAlertAction(title: "Usuń", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
//                self.myFunc.removeSubject(subject: self.subjectKey)
//                self.subjects.remove(at: indexPath.row)
//                self.tableView.reloadData()
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
        edit.backgroundColor = UIColor.lightGray
        //remove.backgroundColor = UIColor.red
        
        return [edit]
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchActive)
        {
            subjectKey = self.filteredKey[indexPath.row]
            editSubject = self.filteredValue[indexPath.row]
        }
        else
        {
            subjectKey = self.keys[indexPath.row]
            editSubject = self.subjects[indexPath.row]
        }
        performSegue(withIdentifier: "goToType", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editSubject")
        {
            let destinationVC = segue.destination as! EditSubjectViewController
            
            destinationVC.subject = editSubject
            destinationVC.subjectKey = subjectKey
        }
        if (segue.identifier == "goToType")
        {
            let destinationVC = segue.destination as! AllClassesTableViewController
            
            destinationVC.subjectKey = subjectKey
        }
        
    }
    
    func loadData()
    {
        myFunc.displayFields{ (name) -> () in
            for item in name
            {
                self.ref.child("subjects").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots
                        {
                            let fieldID = snap.childSnapshot(forPath: "id_field").value as! String
                            let name = snap.childSnapshot(forPath: "name").value as! String
                            let key = snap.key
                            if(fieldID == item.key)
                            {
                                self.subjects.append(name)
                                self.keys.append(key)
                                self.data[snapshot.key] = name
                            }
                        }
                    }
                    self.tableView.reloadData()
                    self.myFunc.hide()
                })
            }
        }

    }
    
}
