//
//  EditSubjectViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 01.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class EditSubjectViewController: UIViewController {
    
    var subject = ""
    var subjectKey = ""
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var ectsText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        ref.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let name = snap.childSnapshot(forPath: "name").value as! String
                    let ects = snap.childSnapshot(forPath: "ECTS").value as! String
                    if(snap.key == self.subjectKey)
                    {
                        self.nameText.text = name
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
    
    
    @IBAction func updateButton(_ sender: Any) {
            
            let nameValue = nameText.text! as String
            let ectsValue = ectsText.text! as String
            
            ref.child("subjects").child(subjectKey).updateChildValues(["name": nameValue,"ECTS": ectsValue])
            
            let okAlert = UIAlertController(title: "Edytowano przedmiot", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            okAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
                
                _ = self.navigationController?.popToViewController(targetController, animated: true)
                
            }))
        
            self.present(okAlert, animated: true, completion: nil)
    }
    
}
