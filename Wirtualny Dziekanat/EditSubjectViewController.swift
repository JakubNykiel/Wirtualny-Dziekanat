//
//  EditSubjectViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 01.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class EditSubjectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var subject = ""
    var subjectKey = ""
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var ectsText: UITextField!
    @IBOutlet weak var semesterText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    var picker = UIPickerView()
    var pickOption = ["1","2","3","4","5","6","7","8"]
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        semesterText.inputView = picker
        ref = FIRDatabase.database().reference()
        
        ref.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let name = snap.childSnapshot(forPath: "name").value as! String
                    let ects = snap.childSnapshot(forPath: "ECTS").value as! String
                    let semester = snap.childSnapshot(forPath: "semester").value as! String
                    if(snap.key == self.subjectKey)
                    {
                        self.nameText.text = name
                        self.semesterText.text = semester
                        self.ectsText.text = ects
                    }
                }
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        semesterText.text = pickOption[row]
    }
    
    @IBAction func updateButton(_ sender: Any) {
            
            let nameValue = nameText.text! as String
            let ectsValue = ectsText.text! as String
            let semesterValue = semesterText.text! as String
            
            ref.child("subjects").child(subjectKey).updateChildValues(["name": nameValue,"ECTS": ectsValue, "semester": semesterValue])
            
            let okAlert = UIAlertController(title: "Edytowano przedmiot", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            okAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
                
                _ = self.navigationController?.popToViewController(targetController, animated: true)
                
            }))
        
            self.present(okAlert, animated: true, completion: nil)
    }
    
}
