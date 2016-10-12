//
//  AddLecturerController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 06.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AddLecturerController: UIViewController {

    var tableResult:String!
    var keyResult:String!
    var type = "Prowadzący"
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var facultyResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        facultyResult.text = tableResult
        ref = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addLecturer(_ sender: AnyObject) {
        
        let name = nameText.text! as String
        let surname = surnameText.text! as String
        let email = emailText.text! as String
        let prof_title = titleText.text! as String
        
        FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Profesor123456") { (user, error) in
            
            let userID:String! = user!.uid
            
            if error != nil
            {
                print("Mamy błąd")
                print(error)
            }
            else
            {
                
                let userData = ["title": prof_title,
                                "name": name,
                                "surname": surname,
                                "email": email,
                                "account_type": self.type]
                
                let tableData = [
                    "id_faculty" : self.keyResult,
                    "id_user" : userID
                ] as [String:String]
                
                self.ref.child("users").child(user!.uid).setValue(userData)
                self.ref.child("user-faculty").childByAutoId().setValue(tableData)
                
            }
        } //end FIR

    }
    
    

}
