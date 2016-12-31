//
//  EditStudentViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 05.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class EditStudentViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: FIRDatabaseReference!
    var userKey = ""
    var myFunc = Functions()
    var fieldID: String!
    var userFieldKey = ""
    var userSemesterKey = ""
    var fieldKey = [String]()
    var updateFieldKey = ""
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var fieldText: UITextField!
    @IBOutlet weak var semesterText: UITextField!
    @IBOutlet weak var numbersText: UITextField!
    
    
    var pickOption = [String]()
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myFunc.displayFields{ (name) -> () in
            for item in name
            {
                self.pickOption.append(item.value)
                self.fieldKey.append(item.key)
            }
        }
        picker.delegate = self
        picker.dataSource = self
        fieldText.inputView = picker
        
        myFunc.show()
        ref = FIRDatabase.database().reference()
        loadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        fieldText.text = pickOption[row]
        updateFieldKey = fieldKey[row]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myFunc.hide()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func updateStudent(_ sender: Any) {
        
        let nameValue = nameText.text! as String
        let surnameValue = surnameText.text! as String
        let semesterValue = semesterText.text! as String
        let numbersValue = numbersText.text! as String
        let fieldValue = fieldText.text! as String
        let userRef = ref.child("users").child(userKey)
        
        userRef.updateChildValues(["name": nameValue,"surname": surnameValue, "number": numbersValue])
        userRef.child("fields").updateChildValues([userFieldKey:semesterValue])
        userRef.child("semester").updateChildValues([userSemesterKey:semesterValue])
        if(userSemesterKey != semesterValue)
        {
            userRef.child("fields").updateChildValues([userFieldKey:semesterValue])
            userRef.child("semester").updateChildValues([semesterValue:true])
            ref.child("semester").child(userSemesterKey).child("users").child(userFieldKey).removeValue()
            ref.child("semester").child(semesterValue).child("users").updateChildValues([userFieldKey:true])
        }
        if(updateFieldKey != userFieldKey)
        {
            //zmiana kierunku w user
            userRef.child("fields").updateChildValues([updateFieldKey:semesterValue])
            
            userRef.child("fields").child(userFieldKey).removeValue()
            
            //usuniecie usera ze starego kierunku
            ref.child("fields").child(userFieldKey).child("users").child(userKey).removeValue()
            
            //dodanie usera do nowego kierunku
            ref.child("fields").child(updateFieldKey).child("users").updateChildValues([userKey:true])
            
            //usuwanie przedmiotow z usera oraz usera z przedmiotow
            userRef.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
                if let subjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for subject in subjects
                    {
                        self.ref.child("subjects").child(subject.key).child("users").child(self.userKey).removeValue()
                        userRef.child("subjects").child(subject.key).removeValue()
                        // usuwanie zajec z usera oraz userow z zajec
                        self.ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let classes = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                for item in classes
                                {
                                    let idSubject = item.childSnapshot(forPath: "id_subject").value as! String
                                    let semester = item.childSnapshot(forPath: "semester").value as! String
                                    if(idSubject == subject.key && semester == semesterValue)
                                    {
                                        self.ref.child("subject-classes").child(item.key).child("users").child(self.userKey).removeValue()
                                        userRef.child("subject-classes").child(item.key).removeValue()
                                    }
                                }
                            }
                        })
                    }
                }
            })
            
            //dodawanie nowych przedmiotow po update
            ref.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
                if let subjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for subject in subjects
                    {
                        let currentSubject = subject.childSnapshot(forPath: "id_field").value as! String
                        if(currentSubject == self.updateFieldKey )
                        {
                            userRef.child("subjects").updateChildValues([subject.key:true])
                            self.ref.child("subjects").child(subject.key).child("users").updateChildValues([self.userKey:true])
                            // dodac dodawanie classes
                            self.ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
                                if let classes = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                    for item in classes
                                    {
                                        let idSubject = item.childSnapshot(forPath: "id_subject").value as! String
                                        let semester = item.childSnapshot(forPath: "semester").value as! String
                                        if(idSubject == subject.key && semester == semesterValue)
                                        {   userRef.child("subject-classes").updateChildValues([item.key:true])
                                            self.ref.child("subject-classes").child(item.key).child("users").updateChildValues([self.userKey:true])
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            })
        }
        
        let okAlert = UIAlertController(title: "Edytowano studenta", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        okAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
            
            _ = self.navigationController?.popToViewController(targetController, animated: true)
            
        }))
        
        self.present(okAlert, animated: true, completion: nil)
    }
    
    func loadData()
    {
        let myRef = self.ref.child("users").child(userKey)
        myRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let name = snapshot.childSnapshot(forPath: "name").value as! String
            let surname = snapshot.childSnapshot(forPath: "surname").value as! String
            let numbers = snapshot.childSnapshot(forPath: "number").value as! String
            myRef.child("fields").child(self.userFieldKey).observeSingleEvent(of: .value, with: { (sem) in
                let semester = sem.value as! String
                if(self.userFieldKey.isEmpty)
                {
                    self.fieldText.text = ""
                    self.nameText.text = name
                    self.surnameText.text = surname
                    self.semesterText.text = semester
                    self.numbersText.text = numbers
                }
                else
                {
                    self.ref.child("fields").child(self.userFieldKey).observeSingleEvent(of: .value, with: { (snapshot) in
                        self.fieldText.text = (snapshot.childSnapshot(forPath: "name").value as? String)!
                        self.nameText.text = name
                        self.surnameText.text = surname
                        self.semesterText.text = semester
                        self.numbersText.text = numbers
                    })
                }
            })
            
        })
        
    }
    
}
