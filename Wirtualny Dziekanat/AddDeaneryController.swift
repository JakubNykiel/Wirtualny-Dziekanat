//
//  AddDeaneryController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 06.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AddDeaneryController: UIViewController {
    
    let functions = Functions()
    var tableResult:String!
    var keyResult:String!
    var type = "Dziekanat"
    var ref: FIRDatabaseReference!
    var myFunc = Functions()
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var facultyResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myFunc.show()
        // Do any additional setup after loading the view.
        facultyResult.text = tableResult
        ref = FIRDatabase.database().reference()
        
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
    
    @IBAction func addDeanery(_ sender: AnyObject) {
        
        myFunc.show()
        let name = nameText.text! as String
        let surname = surnameText.text! as String
        let email = emailText.text! as String
        
        
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
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Dziekanat123456") { (user, error) in
                
                
                if error != nil
                {
                    let errorController = UIAlertController(title: "Bład", message:
                        "Ten email wystepuje w bazie", preferredStyle: UIAlertControllerStyle.alert)
                    errorController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                    }))
                    self.myFunc.hide()
                    self.present(errorController, animated: true, completion: nil)
                }
                else
                {
                    
                    let userData = ["name": name,
                                    "surname": surname,
                                    "email": email,
                                    "account_type": self.type]
                    
                    let tableData = [
                        "id_faculty" : self.keyResult,
                        "id_user" : (user?.uid)!
                        ] as [String:String]
                    
                    self.ref.child("users").child((user?.uid)!).setValue(userData)
                    self.ref.child("user-faculty").childByAutoId().setValue(tableData)
                    
                    let alertController = UIAlertController(title: "Dodano użytkownika", message:
                        "Dodawanie uzytkownika zostało zakończone", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                        let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 4]
                        
                        _ = self.navigationController?.popToViewController(targetController, animated: true)
                    }))
                    self.myFunc.hide()
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            } //end FIR
            
            
            
        }
    }
    
}
