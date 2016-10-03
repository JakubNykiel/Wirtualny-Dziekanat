//
//  DziekanatMenuController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 09.06.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class DziekanatAddUserController: UIViewController {
    
    let myFunctions = Functions()
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var titlesText: UITextField!
    
    @IBOutlet weak var facultyResult: UILabel!
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var faculty = [String]()
    var semester = [String]()
    var student = [String:AnyObject]()
    var account_type : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        ref.child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
//            self.faculty = snapshot.value as! [String]
//        })
//        ref.child("semester").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
//            self.semester = snapshot.value as! [String]
//        })
//        ref.child("student").child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
//            self.student = [:]
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshots {
//                   let key = snap.key
//                }
//            }
//        })
        print(account_type)
        ref = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func addUserButton(_ sender: AnyObject) {
        
        let name = nameText.text! as String
        let surname = surnameText.text! as String
        let email = emailText.text! as String
        
        if (self.account_type == "Student")
        {
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Student123456") { (user, error) in
                
                if error != nil
                {
                    print("Mamy błąd")
                    print(error)
                }
                else
                {
                    //                    let newUser = [
                    //                        "name" : name,
                    //                        "surname" : surname,
                    //                        "email" : email,
                    //                        "account_type": self.account_type
                    //                    ]
                    
                    //                    self.ref.child("users").child((user?.uid)!).setValue(newUser)
                }
            } //end FIR
        } //end if
        
        if (self.account_type == "Dziekanat")
        {
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Dziekanat123456") { (user, error) in
                
                if error != nil
                {
                    print("Mamy błąd")
                    print(error)
                }
                else
                {
                    
                    let data = ["name": name,
                                "surname": surname,
                                "email": email,
                                "account_type": self.account_type as String]
                    print(data)
                    self.ref.child("users").child(user!.uid).setValue(data)
                }
            } //end FIR
        } //end if
        
        if (self.account_type == "Profesor")
        {
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Profesor123456") { (user, error) in
                
                if error != nil
                {
                    print("Mamy błąd")
                    print(error)
                }
                else
                {
                    //                    let newUser = [
                    //                        "name" : name,
                    //                        "surname" : surname,
                    //                        "email" : email,
                    //                        "account_type": self.account_type
                    //                    ]
                    
                    //                    self.ref.child("users").child((user?.uid)!).setValue(newUser)
                }
            } //end FIR
        } //end if

    }
    
}

