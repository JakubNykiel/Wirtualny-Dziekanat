//
//  LoginController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 21.05.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.borderStyle = UITextBorderStyle.RoundedRect
        passwordTextField.borderStyle = UITextBorderStyle.RoundedRect
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


}
