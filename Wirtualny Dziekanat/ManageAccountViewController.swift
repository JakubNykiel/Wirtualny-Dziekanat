//
//  ManageAccountViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 16.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class ManageAccountViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var myFunc = Functions()
    var userKey: String!
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        userKey = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userKey!).child("account_type").observeSingleEvent(of: .value, with: { (snapshot) in
            self.type = snapshot.value as! String
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteUserAccount(_ sender: Any) {
        
        let alert = UIAlertController(title: "Czy jesteś pewien?", message: "Twoje konto zostanie usunięte bezpowrotnie", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Powrót", style: UIAlertActionStyle.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Usuń", style: UIAlertActionStyle.destructive, handler: { (action: UIAlertAction!) in
            
            FIRAuth.auth()?.currentUser?.delete(completion: { (error) in
                if((error) != nil)
                {
                    print(error.debugDescription)
                }
                else
                {
                    if(self.type == "Dziekanat")
                    {
                        self.myFunc.removeDeanery(user: self.userKey)
                    }
                    
                    if(self.type == "Prowadzący")
                    {
                        self.myFunc.removeLecturer(user: self.userKey)
                    }
                    if(self.type == "Student")
                    {
                       self.myFunc.removeStudent(user: self.userKey)
                    }
                    if let storyboard = self.storyboard {
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginScene")
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            })
            
        })) // end of remove alert action
        self.present(alert, animated: true, completion: nil)
    }// end of IBAction
    
}
