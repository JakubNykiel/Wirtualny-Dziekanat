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
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var numbersText: UITextField!
    @IBOutlet weak var titlesText: UITextField!
    
    @IBOutlet weak var facultyResult: UILabel!
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var faculty = [String]()
    var semester = [String]()
    var student = [String:AnyObject]()
    var account_type = ""
   
    @IBOutlet weak var dziekanatButton: UIButton!
    
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
    
//    @IBAction func addDziekanatUserButton(_ sender: AnyObject) {
//        
////        let password = "s" + numbersText.text!
//        
//
//        FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Test123456") { (user, error) in
//            
//            if error != nil {
//                print("Mamy błąd")
//                print(error)
//            } else {
//                
//                print(user?.uid)
//                
//                
//                let newUser = [
//                    "account_type": "Dziekanat"
//                ]
//               
//                self.ref.child("users")
//                    .child((user?.uid)!).childByAutoId().setValue(newUser)
//            }
//
//        }
//        
//    }
}

