//
//  LoginController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 21.05.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let functions = Functions()
    
    @IBAction func loginButton(_ sender: AnyObject) {
        let email = emailTextField.text
        
        let password = passwordTextField.text
        
        if email!.isEmpty || password!.isEmpty
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Niektóre pola są puste!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else if functions.validateEmail(email!) == false
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Musisz wpisać email!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    // an error occured while attempting login
                    let alertController = UIAlertController(title: "Wystąpił Błąd", message:
                        "Proszę spróbować ponownie!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Spróbuj ponownie", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    // user is logged in, check authData for data
                    //tu oczywiscie nalezy zmienic !!!!!!!!
                    self.performSegue(withIdentifier: "DziekanatMenu", sender: nil)
                }
            }
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            // ...
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
