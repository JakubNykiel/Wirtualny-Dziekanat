//
//  EditFieldViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 29.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class EditFieldViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    var field = ""
    var fieldKey = ""
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        nameText.text = field
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func updateButton(_ sender: Any) {
        let value = nameText.text! as String
        ref.child("fields").child(fieldKey).updateChildValues(["name": value])
        let alert = UIAlertController(title: "Edytowano kierunek", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
            
            _ = self.navigationController?.popToViewController(targetController, animated: true)

        }))
        self.present(alert, animated: true, completion: nil)
    }

}
