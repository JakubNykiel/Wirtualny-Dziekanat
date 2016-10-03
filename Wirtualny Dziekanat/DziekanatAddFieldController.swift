//
//  DziekanatAddFieldController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 28.09.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class DziekanatAddFieldController: UIViewController {

    var ref: FIRDatabaseReference!

    var tableResult = ""
    var keyResult = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var facultyResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        facultyResult.text = tableResult
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    @IBAction func addFieldOfStudy(_ sender: AnyObject) {
        
        if (nameTextField.text?.isEmpty)! 
        {
            let alertController = UIAlertController(title: "Nie można dodać kierunku", message:
                "Nie uzupełniono wszystkich pól", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let name = nameTextField.text! as String
            let id_faculty = keyResult as String
            let data = ["name": name,
                        "id_faculty": id_faculty]
            print(data)
            self.ref.child("fields").childByAutoId().setValue(data)
            
            let alertController = UIAlertController(title: "Dodano kierunek", message:
                "Dodawanie kierunku zostało zakończone", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Menu", style: .cancel, handler: { (action: UIAlertAction!) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            alertController.addAction(UIAlertAction(title: "Dodaj kolejny", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
