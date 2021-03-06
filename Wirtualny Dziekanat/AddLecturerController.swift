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
    
    let functions = Functions()
    var tableResult:String!
    var keyResult:String!
    var type = "Prowadzący"
    var ref: FIRDatabaseReference!
    var myFunc = Functions()
    let faculty = Faculty()
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var facultyResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()
        
        myFunc.show()
        ref = FIRDatabase.database().reference()
        
        faculty.displayFaculty{ (name) -> () in
            for item in name
            {
                self.keyResult = item.key
                self.tableResult = item.value
                self.facultyResult.text = item.value
            }

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myFunc.hide()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addLecturer(_ sender: AnyObject) {
        
        myFunc.show()
        let name = nameText.text! as String
        let surname = surnameText.text! as String
        let email = emailText.text! as String
        let prof_title = titleText.text! as String
        
        
        if (email.isEmpty || surname.isEmpty || name.isEmpty)
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Niektóre pola są puste!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            myFunc.hide()
            self.present(alertController, animated: true, completion: nil)
        }
        else if (functions.validateEmail(email) == false)
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Wpisz poprawny email.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            myFunc.hide()
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Profesor123456") { (user, error) in
                
                let userID:String! = user!.uid
                
                if error != nil
                {
                    print("Mamy błąd")
                }
                else
                {
                    
                    let userData = ["title": prof_title,
                                    "name": name,
                                    "surname": surname,
                                    "email": email,
                                    "account_type": self.type,
                                    "faculty": [self.keyResult:true]] as [String : Any]
                    
                    self.ref.child("users").child(user!.uid).setValue(userData)
                    self.ref.child("faculty").child(self.keyResult).child("users").updateChildValues([userID:true])
                }
            } //end FIR
            
            let alertController = UIAlertController(title: "Dodano użytkownika", message:
                "Dodawanie uzytkownika zostało zakończone", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 4]
                
                // And go to that Controller
                _ = self.navigationController?.popToViewController(targetController, animated: true)
            }))
            myFunc.hide()
            self.present(alertController, animated: true, completion: nil)
        } // end else
    }
    
    
    
}
