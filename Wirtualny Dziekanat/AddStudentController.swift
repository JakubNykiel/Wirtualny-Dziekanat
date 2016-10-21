//
//  AddStudentController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 06.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AddStudentController: UIViewController {
    
    let functions = Functions()
    var tableResult:[String]!
    var keyResult:[String]!
    var type = "Student"
    var ref: FIRDatabaseReference!
    let myFunc = Functions()
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var facultyResult: UILabel!
    @IBOutlet weak var fieldResult: UILabel!
    @IBOutlet weak var semesterResult: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        myFunc.displayFaculty{ (name) -> () in
            if name.characters.count > 0 {
                self.facultyResult.text = name
            }
            else {
                print("Not found")
            }
        }

        fieldResult.text = tableResult[1]
        semesterResult.text = tableResult[2]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addStudent(_ sender: AnyObject) {
        
        let name = nameText.text! as String
        let surname = surnameText.text! as String
        let email = emailText.text! as String
        
        
        if (email.isEmpty || surname.isEmpty || name.isEmpty)
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Niektóre pola są puste!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else if functions.validateEmail(email) == false
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Wpisz poprawny email.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Student123456") { (user, error) in
                
                let userID:String! = user!.uid
                
                if error != nil
                {
                    print("Mamy błąd")
                    print(error)
                }
                else
                {
                    let userData = [
                        "name" : name,
                        "surname" : surname,
                        "email" : email,
                        "account_type": self.type,
                        "semester": self.keyResult[2]
                    ]
                    
                    let tableData = [
                        "id_faculty" : self.keyResult[0],
                        "id_user" : userID
                        ] as [String:String]
                    
                    let userField = [
                        "id_field" : self.keyResult[1],
                        "id_user" : userID
                    ] as [String:String]
                    
                    self.ref.child("users").child(user!.uid).setValue(userData)
                    self.ref.child("user-faculty").childByAutoId().setValue(tableData)
                    self.ref.child("user-field").childByAutoId().setValue(userField)
                }
            } //end FIR
            
            //zakonczenie dodawania uzytkownika:
            let alertController = UIAlertController(title: "Dodano użytkownika", message:
                "Dodawanie uzytkownika zostało zakończone", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 6]
                
                _ = self.navigationController?.popToViewController(targetController, animated: true)
            }))
            self.present(alertController, animated: true, completion: nil)
            
        }
        //na koniec usuwamy dane
    }
    
    
}
