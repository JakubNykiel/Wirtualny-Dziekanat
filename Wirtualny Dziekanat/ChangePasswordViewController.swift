//
//  ChangePasswordViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 15.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var ref: FIRDatabaseReference!
    var myFunc = Functions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        let password = passwordText.text! as String
        let confirm = confirmPassword.text! as String
        
        if password.isEmpty || confirm.isEmpty
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Niektóre pola są puste!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            myFunc.hide()
        }
        else if(password != confirm)
        {
            let alertController = UIAlertController(title: "Błąd", message:
                "Hasła nie są takie same", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.currentUser?.updatePassword(password, completion: { (error) in
                if((error) != nil)
                {
                    print(error.debugDescription)
                }
                else
                {
                    let alertController = UIAlertController(title: "Zmieniono hasło", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                        let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
                        
                        _ = self.navigationController?.popToViewController(targetController, animated: true)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }

    }

}
