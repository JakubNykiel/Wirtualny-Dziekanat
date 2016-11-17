//
//  ChangeEmailViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 15.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    var ref: FIRDatabaseReference!
    var myFunc = Functions()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        emailText.text = FIRAuth.auth()?.currentUser?.email
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        
        let email = emailText.text! as String

        if email.isEmpty
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Niektóre pola są puste!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            myFunc.hide()
        }
        else if myFunc.validateEmail(email) == false
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Wpisz poprawny email.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            myFunc.hide()
        }
        else
        {
            FIRAuth.auth()?.currentUser?.updateEmail(email, completion: { (error) in
                if((error) != nil)
                {
                    print(error.debugDescription)
                }
                else
                {
                    let userKey = FIRAuth.auth()?.currentUser?.uid
                    self.ref.child("users").child(userKey!).updateChildValues(["email": email])
                    
                    let alertController = UIAlertController(title: "Zmieniono email", message:
                        "Nowy email: " + email, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                        let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
                        
                        _ = self.navigationController?.popToViewController(targetController, animated: true)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    } //end ibaction
}
