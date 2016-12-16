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
    @IBOutlet weak var numberText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myFunc.show()
        ref = FIRDatabase.database().reference()
        
        myFunc.displayFaculty{ (name) -> () in
            for item in name
            {
                self.keyResult[0] = item.key
                self.tableResult[0] = item.value
                self.facultyResult.text = item.value
            }

        }

        fieldResult.text = tableResult[1]
        semesterResult.text = tableResult[2]
        
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
    
    @IBAction func addStudent(_ sender: AnyObject) {
        
        myFunc.show()
        let name = nameText.text! as String
        let surname = surnameText.text! as String
        let email = emailText.text! as String
        let number = numberText.text! as String
        
        
        if (email.isEmpty || surname.isEmpty || name.isEmpty)
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Niektóre pola są puste!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            myFunc.hide()
            self.present(alertController, animated: true, completion: nil)
        }
        else if myFunc.validateEmail(email) == false
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Wpisz poprawny email.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            myFunc.hide()
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Student123456") { (user, error) in
                
                let userID:String! = user!.uid
                
                if error != nil
                {
                    print("Mamy błąd")
                }
                else
                {
                    let userData = [
                        "name" : name,
                        "surname" : surname,
                        "email" : email,
                        "account_type": self.type,
                        "semester": [self.keyResult[2]:true],
                        "number": number,
                        "faculty":[self.keyResult[0]:true],
                        "fields":[self.keyResult[1]:self.keyResult[2]]
                    ] as [String : Any]
                    
                    self.ref.child("users").child(user!.uid).setValue(userData)
                    self.ref.child("fields").child(self.keyResult[1]).child("users").updateChildValues([userID:true])
                    self.ref.child("faculty").child(self.keyResult[0]).child("users").updateChildValues([userID:true])
                    self.ref.child("semester").child(self.keyResult[2]).child("users").updateChildValues([userID:true])
                    
                    self.ref.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            
                            for snap in snapshots
                            {
                                let semester = snap.childSnapshot(forPath: "semester").value as! String
                                let field = snap.childSnapshot(forPath: "id_field").value as! String
                                if(semester == self.keyResult[2] && field == self.keyResult[1])
                                {
                                    self.ref.child("users").child(userID).child("subjects").updateChildValues([snap.key:true])
                                    self.ref.child("subjects").child(snap.key).child("users").updateChildValues([userID:true])
                                    self.ref.child("subject-classes").observeSingleEvent(of: .value, with: { (subcla) in
                                        if let classes = subcla.children.allObjects as? [FIRDataSnapshot] {
                                            for classItem in classes
                                            {
                                                let subjectID = classItem.childSnapshot(forPath: "id_subject").value as! String
                                                if(subjectID == snap.key)
                                                {
                                                    self.ref.child("users").child(userID).child("subject-classes").updateChildValues([classItem.key:true])
                                                    self.ref.child("subject-classes").child(classItem.key).child("users").updateChildValues([userID:true])
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    })
                }
            } //end FIR
            
            //zakonczenie dodawania uzytkownika:
            let alertController = UIAlertController(title: "Dodano użytkownika", message:
                "Dodawanie uzytkownika zostało zakończone", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 6]
                
                _ = self.navigationController?.popToViewController(targetController, animated: true)
            }))
            myFunc.hide()
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
}
