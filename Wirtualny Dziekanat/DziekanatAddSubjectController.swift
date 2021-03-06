//
//  DziekanatAddSubjectController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 20.09.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class DziekanatAddSubjectController: UIViewController {

    @IBOutlet weak var ectsText: UITextField!
    @IBOutlet weak var subjectText: UITextField!
    @IBOutlet weak var facultyResult: UILabel!
    @IBOutlet weak var fieldResult: UILabel!
    @IBOutlet weak var semesterResult: UILabel!
    
    var myFunc = Functions()
    let faculty = Faculty()
    var ref: FIRDatabaseReference!
    var tableResult:[String]!
    var keyResult:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myFunc.show()
        ref = FIRDatabase.database().reference()
        
        faculty.displayFaculty{ (name) -> () in
            for item in name
            {
                self.keyResult[0] = item.key
                self.tableResult[0] = item.value
                self.facultyResult.text = item.value
            }

        }
        
        fieldResult.text = tableResult[1]
        semesterResult.text = tableResult[2]
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
    
    @IBAction func addSubjectButton(_ sender: AnyObject) {
        myFunc.show()
        if( (subjectText.text?.isEmpty)! || (ectsText.text?.isEmpty)! )
        {
            let alertController = UIAlertController(title: "Nie można dodać kierunku", message:
                "Nie uzupełniono wszystkich pól", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Popraw", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let name = subjectText.text! as String
            let id_field = keyResult[1] as String
            let ects = ectsText.text! as String
            let semester = keyResult[2] as String
            let data = ["name": name,
                        "ECTS": ects,
                        "id_field": id_field,
                        "semester": semester]
            let myRef = self.ref.child("subjects").childByAutoId()
            myRef.setValue(data)
            let userData = [myRef.key:0]
            
            self.ref.child("fields").child(id_field).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if let users = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for user in users
                    {
                        self.ref.child("users").child(user.key).child("semester").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let semesters = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                for sem in semesters
                                {
                                    if(sem.key == semester)
                                    {
                                        self.ref.child("users").child(user.key).child("subjects").updateChildValues(userData)
                                        self.ref.child("subjects").child(myRef.key).child("users").updateChildValues([user.key:true])
                                    }
                                }
                            }
                        })
                    }
                }
            })
            self.ref.child("users")
            let alertController = UIAlertController(title: "Dodano przedmiot", message:
                "Dodawanie przedmioto zostało zakończone", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Menu", style: .cancel, handler: { (action: UIAlertAction!) in
                let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 4]
                
                _ = self.navigationController?.popToViewController(targetController, animated: true)
                
            }))
            myFunc.hide()
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
