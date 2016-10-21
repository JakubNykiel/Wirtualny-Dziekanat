//
//  LoginController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 21.05.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let functions = Functions()
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        emailTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        ref = FIRDatabase.database().reference()
        
        emailTextField.text = "wggios@dziekanat.agh"
        passwordTextField.text = "Dziekanat123456"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        
        Functions.show("Ładowanie")
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email!.isEmpty || password!.isEmpty
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Niektóre pola są puste!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            Functions.hide()
        }
        else if functions.validateEmail(email!) == false
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Wpisz poprawny email.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            Functions.hide()
        }
        else //właściwe logowanie
        {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error != nil {
                    // an error occured while attempting login
                    let alertController = UIAlertController(title: "Wystąpił Błąd", message:
                        "Proszę spróbować ponownie!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Spróbuj ponownie", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    Functions.hide()
                }
                else
                {
                    Functions.hide()
                    let currentUser = FIRAuth.auth()?.currentUser
                    let userID = currentUser!.uid
                    self.ref.child("users").child(userID).child("account_type").observeSingleEvent(of: .value, with: { (snapshot) in
                        let type = snapshot.value as! String
                        
                        if(type == "Dziekanat")
                        {
                            self.performSegue(withIdentifier: "DziekanatMenu", sender: nil)
                        }
                        if(type == "Student")
                        {
                            self.performSegue(withIdentifier: "StudentMenu", sender: nil)
                        }
                        if(type == "Prowadzący")
                        {
                            self.performSegue(withIdentifier: "ProfesorMenu", sender: nil)
                        }
                    })
                    
                }
            }
            
        }
    }
    
    
    
}
