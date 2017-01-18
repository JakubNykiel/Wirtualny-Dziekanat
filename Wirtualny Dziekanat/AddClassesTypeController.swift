//
//  AddClassesTypeController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 24.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AddClassesTypeController: UIViewController {
    
    var classesData = [String]()
    var classesDataDisplay = [String]()
    var myFunc = Functions()
    var ref: FIRDatabaseReference!
    var myDict = [String: [String:String]]()
    
    @IBOutlet weak var subjectResult: UILabel!
    @IBOutlet weak var classesTypeResult: UILabel!
    @IBOutlet weak var lecturerResult: UILabel!
    @IBOutlet weak var hoursText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        subjectResult.text = classesDataDisplay[0]
        classesTypeResult.text = classesDataDisplay[1]
        lecturerResult.text = classesDataDisplay[2]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addClassesType(_ sender: AnyObject) {
        
        let hours = hoursText.text! as String
        myFunc.show()
        
        let data = ["hours": hours,
                    "id_subject": self.classesData[1],
                    "id_type": self.classesData[2],
                    "id_lecturer": self.classesData[3]
        ]
        
        let myRef = self.ref.child("subject-classes").childByAutoId()
        myRef.setValue(data)
        let userData = [myRef.key: data]
        self.ref.child("users").child(self.classesData[3]).child("subject-classes").updateChildValues([myRef.key:true])
        //self.ref.child("users").child(self.classesData[3]).child("subjects").updateChildValues([self.classesData[1]:true])
        let subjRef = self.ref.child("users").child(self.classesData[3])
        
        subjRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.hasChild("subjects"))
            {
                subjRef.child("subjects").observeSingleEvent(of: .value, with: { (subInfo) in
                    if let userSubjects = subInfo.children.allObjects as? [FIRDataSnapshot] {
                        for userSubject in userSubjects
                        {
                            if(subInfo.hasChild(self.classesData[1]))
                            {
                                if(userSubject.key == self.classesData[1])
                                {
                                    self.ref.child("users").child(self.classesData[3]).child("subjects").updateChildValues([self.classesData[1]: userSubject.value as! Int + 1])
                                }
                            }
                            else
                            {
                                self.ref.child("users").child(self.classesData[3]).child("subjects").updateChildValues([self.classesData[1]: 1])
                            }
                        }
                    }
                })
                
            }
            else
            {
                self.ref.child("users").child(self.classesData[3]).child("subjects").updateChildValues([self.classesData[1]: 1])
            }
        })
        
        self.ref.child("subjects").child(self.classesData[1]).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let users = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for user in users
                {
                    self.ref.child("users").child(user.key).child("subject-classes").updateChildValues([myRef.key: true])
                    self.ref.child("subject-classes").child(myRef.key).child("users").updateChildValues([user.key:true])
                    self.ref.child("users").child(user.key).child("subjects").child(self.classesData[1]).observeSingleEvent(of: .value, with: { (userSubject) in
                        self.ref.child("users").child(user.key).child("subjects").updateChildValues([userSubject.key:userSubject.value as! Int + 1])
                    })
                }
            }
       })
        
        
        let alertController = UIAlertController(title: "Dodano kierunek", message:
            "Dodawanie kierunku zostało zakończone", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Menu", style: .cancel, handler: { (action: UIAlertAction!) in
            self.myFunc.show()
            let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 9]
            
            _ = self.navigationController?.popToViewController(targetController, animated: true)
            self.myFunc.hide()
        }))
        alertController.addAction(UIAlertAction(title: "Dodaj typ", style: .default, handler: { (action: UIAlertAction!) in
            self.myFunc.show()
            let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 3]
            
            _ = self.navigationController?.popToViewController(targetController, animated: true)
            self.myFunc.hide()
        }))
        
        myFunc.hide()
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
