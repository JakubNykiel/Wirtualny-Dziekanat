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
        
        let userField = [
            "id_field": classesData[0],
            "id_user": classesData[3]]
        self.ref.child("user-field").childByAutoId().setValue(userField)
        
        
        self.ref.child("user-field").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let user = snap.childSnapshot(forPath: "id_user").value as! String
                    let fieldID = snap.childSnapshot(forPath: "id_field").value as! String
                    if(user == self.classesData[3] && fieldID == self.classesData[0])
                    {
                        let data = ["hours": hours,
                                    "id_subject": self.classesData[1],
                                    "id_type": self.classesData[2],
                                    "id_lecturer": self.classesData[3],
                                    "userField": snap.key]
                        self.ref.child("subject-classes").childByAutoId().setValue(data)
                    }
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
