//
//  AllFieldsListTableViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 26.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AllFieldsListTableViewController: UITableViewController, UISearchBarDelegate {
    
    var ref: FIRDatabaseReference!
    var field = [String]()
    var keys = [String]()
    var myFunc = Functions()
    var editField = ""
    var fieldKey = ""
    var data = ["":""]
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keys.removeAll()
        field.removeAll()
        
        myFunc.displayFields{ (name) -> () in
            for item in name
            {
                self.keys.append(item.key)
                self.field.append(item.value)
                self.data[item.key] = item.value
            }
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "fields", for: indexPath)
        
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
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        if(searchActive) {
            fieldKey = self.filteredKey[indexPath.row]
            editField = self.filteredValue[indexPath.row]
        }
        else
        {
            fieldKey = self.keys[indexPath.row]
            editField = field[indexPath.row]
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edytuj") { action, index in
            self.performSegue(withIdentifier: "editField", sender: self)
        }
        
        let remove = UITableViewRowAction(style: .normal, title: "Usuń") { action, index in
            let alert = UIAlertController(title: "Czy jesteś pewien?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Powrót", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Usuń", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.myFunc.show()
                self.myFunc.removeField(field: self.fieldKey)
                self.field.remove(at: indexPath.row)
                self.keys.remove(at: indexPath.row)
                self.data.removeValue(forKey: self.fieldKey)
                self.tableView.reloadData()
                self.myFunc.hide()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editField")
        {
            let destinationVC = segue.destination as! EditFieldViewController
            
            destinationVC.field = editField
            destinationVC.fieldKey = fieldKey
        }
        
    }
    
    
    
}
