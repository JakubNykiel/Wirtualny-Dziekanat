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
        
        ref.child("users").child(userKey).updateChildValues(["name": nameValue,"surname": surnameValue, "semester": semesterValue, "number": numbersValue])
        ref.child("user-field").child(userFieldKey).updateChildValues(["id_field": updateFieldKey])
        
        let okAlert = UIAlertController(title: "Edytowano studenta", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        okAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
            
            _ = self.navigationController?.popToViewController(targetController, animated: true)
            
        }))
        
        self.present(okAlert, animated: true, completion: nil)
        
        
    }
    
    func loadData()
    {
        self.ref.child("user-field").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let userID = snap.childSnapshot(forPath: "id_user").value as! String
                    
                    if(self.userKey == userID)
                    {
                        self.fieldID =  snap.childSnapshot(forPath: "id_field").value as! String
                        self.userFieldKey = snap.key
                    }
                }
            }
        })
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let account = snap.childSnapshot(forPath: "account_type").value as! String
                    if(account == "Student")
                    {
                        let name = snap.childSnapshot(forPath: "name").value as! String
                        let surname = snap.childSnapshot(forPath: "surname").value as! String
                        let semester = snap.childSnapshot(forPath: "semester").value as! String
                        let numbers = snap.childSnapshot(forPath: "number").value as! String
                        if(snap.key == self.userKey)
                        {
                            
                            if(self.fieldID.isEmpty)
                            {
                                self.fieldText.text = ""
                                self.nameText.text = name
                                self.surnameText.text = surname
                                self.semesterText.text = semester
                                self.numbersText.text = numbers
                            }
                            else
                            {
                                self.ref.child("fields").child(self.fieldID).observeSingleEvent(of: .value, with: { (snapshot) in
                                    self.fieldText.text = (snapshot.childSnapshot(forPath: "name").value as? String)!
                                    self.nameText.text = name
                                    self.surnameText.text = surname
                                    self.semesterText.text = semester
                                    self.numbersText.text = numbers
                                })
                            }
                        }
                    }
                }
            }
        })
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
