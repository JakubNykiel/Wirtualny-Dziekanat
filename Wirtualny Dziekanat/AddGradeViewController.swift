//
//  AddGradeViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 28.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AddGradeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var mySubject = ""
    var mySubjectType = ""
    var myDate = ""
    var userData = [String:String]()
    var ref: FIRDatabaseReference!
    var myFunc = Functions()
    var grades = [2.0,3.0,3.5,4.0,4.5,5.0]
    var gradeData = [String:Any]()
    var picker = UIPickerView()
    
    @IBOutlet weak var gradeText: UITextField!
    @IBOutlet weak var usersTextView: UITextView!
    @IBOutlet weak var date: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        usersTextView.isEditable = false
        date.text = myDate
        for item in userData
        {
            usersTextView.text.append(item.value + "\n")
        }
        picker.delegate = self
        picker.dataSource = self
        gradeText.inputView = picker

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return grades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(grades[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        gradeText.text = "\(grades[row])"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func addGrade(_ sender: Any) {
        
        for item in userData
        {
            if(myDate == "Termin 1")
            {
                gradeData = ["id_classes": mySubject,
                                 "user": item.key,
                                 "dates": ["1": Double(self.gradeText.text!)]]
            }
            else if(myDate == "Termin 2")
            {
                gradeData = ["dates": ["2": Double(self.gradeText.text!)]]
            }
            else
            {
                gradeData = ["dates": ["3": Double(self.gradeText.text!)]]
            }
            let autoKey = ref.childByAutoId().key
            ref.child("grades").child(autoKey).updateChildValues(gradeData)
            ref.child("subject-classes").child(mySubject).child("grades").updateChildValues([autoKey:true])
            ref.child("users").child(item.key).child("grades").updateChildValues([autoKey:true])
        }
        
        let alertController = UIAlertController(title: "Dodano oceny", message:
            "Dodawanie ocen zostało zakończone", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
            let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
            
            _ = self.navigationController?.popToViewController(targetController, animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
