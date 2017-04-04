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
    
    var tableResult:String!
    var keyResult:String!
    let myFunc = Functions()
    let faculty = Faculty()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var facultyResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        myFunc.show("Ładowanie")
        faculty.displayFaculty{ (name) -> () in
            for item in name
            {
                self.keyResult = item.key
                self.tableResult = item.value
                self.facultyResult.text = item.value
            }

        }
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
            myFunc.show()
            let name = nameTextField.text! as String
            let id_faculty = keyResult as String
            let data = ["name": name,
                        "id_faculty": id_faculty]
            self.ref.child("fields").childByAutoId().setValue(data)
            myFunc.hide()
            let alertController = UIAlertController(title: "Dodano kierunek " + name, message:nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Menu", style: .cancel, handler: { (action: UIAlertAction!) in
                self.myFunc.show()
                let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 3]
                
               _ = self.navigationController?.popToViewController(targetController, animated: true)
                self.myFunc.hide()
            }))
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
}
