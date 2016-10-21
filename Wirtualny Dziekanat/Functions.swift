//
//  Functions.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 09.06.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Functions
{
    func validateEmail(_ value: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: value)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setAnimationView(_ view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
            view.isHidden = hidden
            }, completion: { _ in })
    }
    func displayFaculty(completion: @escaping (String)->()){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()

        let userID = FIRAuth.auth()!.currentUser!.uid

        var value = ""
        
        ref.child("user-faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
        
                for snap in snapshots
                {
                    
                    let fn = snap.childSnapshot(forPath: "id_faculty").value as! String
                    let sn = snap.childSnapshot(forPath: "id_user").value as! String
                    
                    if(sn == userID)
                    {
                        value = fn
                    }
                }
            }
        })
        ref.child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let fn = snap.childSnapshot(forPath: "id").value as! String
                    let sn = snap.childSnapshot(forPath: "name").value as! String
                    
                    if(fn == value)
                    {
                        completion(sn)
                    }
                    
                }
            }
        })
    }
    
    func displayFields(completion: @escaping ([String:String])->()){
        var ref:FIRDatabaseReference
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()!.currentUser!.uid
        var value = ""
        var dict = [String:String]()
        
        ref.child("user-faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let fn = snap.childSnapshot(forPath: "id_faculty").value as! String
                    let sn = snap.childSnapshot(forPath: "id_user").value as! String
                    
                    if(sn == userID)
                    {
                        value = fn
                    }
                }
            }
        })
        
        ref.child("fields").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let fn = snap.childSnapshot(forPath: "id_faculty").value as! String
                    let sn = snap.childSnapshot(forPath: "name").value as! String
                    if(fn == value)
                    {
                        dict[snap.key] = sn
                        completion(dict)
                        dict.removeAll()
                    }
                }
                
                
            }
        })

    }
}
