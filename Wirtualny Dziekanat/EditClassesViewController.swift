//
//  EditClassesViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 16.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class EditClassesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: FIRDatabaseReference!
    var myFunc = Functions()
    var keys = [String]()
    var lecturerDisplay = String()
    var lecturer = [String]()
    var currentClass = String()
    var classesKey = String()
    var pickerKey = String()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lecturerText: UITextField!
    @IBOutlet weak var hoursText: UITextField!
    
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFunc.displayLecturer{ (name) -> () in
            for item in name
            {
                self.keys.append(item.key)
                self.lecturerDisplay = item.value[0] + " " + item.value[1] + " " + item.value[2]
                self.lecturer.append(self.lecturerDisplay)
                
            }
        }
        picker.delegate = self
        picker.dataSource = self
        lecturerText.inputView = picker
        
        myFunc.show()
        ref = FIRDatabase.database().reference()
        loadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return lecturer.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lecturer[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        lecturerText.text = lecturer[row]
        pickerKey = keys[row]
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
    
    @IBAction func updateButton(_ sender: Any) {
        
        let hoursValue = hoursText.text! as String
        
        ref.child("subject-classes").child(classesKey).updateChildValues(["hours": hoursValue,"id_lecturer": pickerKey])
        
        let okAlert = UIAlertController(title: "Edytowano przedmiot", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        okAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
            
            _ = self.navigationController?.popToViewController(targetController, animated: true)
            
        }))
        
        self.present(okAlert, animated: true, completion: nil)
        
    }
    
    func loadData()
    {
        
        ref.child("subject-classes").child(classesKey).observeSingleEvent(of: .value, with: { (snapshot) in
            let idLecturer = snapshot.childSnapshot(forPath: "id_lecturer").value as! String
            let hours = snapshot.childSnapshot(forPath: "hours").value as! String
            let lecturerIndex = self.keys.index(of: idLecturer)
            self.nameLabel.text = self.currentClass
            self.hoursText.text = hours
            self.lecturerText.text = self.lecturer[lecturerIndex!]
        })
        
    }

}
