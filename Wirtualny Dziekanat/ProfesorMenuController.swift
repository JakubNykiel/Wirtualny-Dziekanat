//
//  ProfesorMenuController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 03.07.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class ProfesorMenuController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signOutButton(_ sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginScene")
            self.present(vc, animated: false, completion: nil)
        }

    }

}
