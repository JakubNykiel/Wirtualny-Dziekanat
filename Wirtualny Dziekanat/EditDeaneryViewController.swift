//
//  EditDeaneryViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 05.11.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class EditDeaneryViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var userKey = ""
    var myFunc = Functions()

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myFunc.show()
        ref = FIRDatabase.database().reference()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myFunc.hide()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButton(_ sender: Any) {
        let nameValue = nameText.text! as String
        let surnameValue = surnameText.text! as String
        
        ref.child("users").child(userKey).updateChildValues(["name": nameValue,"surname": surnameValue])
        
        
        let okAlert = UIAlertController(title: "Edytowano konto dziekanatu", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        okAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
            
            _ = self.navigationController?.popToViewController(targetController, animated: true)
            
        }))
        
        self.present(okAlert, animated: true, completion: nil)

    }
    
    func loadData()
    {
        
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let account = snap.childSnapshot(forPath: "account_type").value as! String
                    if(account == "Dziekanat")
                    {
                        let name = snap.childSnapshot(forPath: "name").value as! String
                        let surname = snap.childSnapshot(forPath: "surname").value as! String
                    
                        if(snap.key == self.userKey)
                        {
                            self.nameText.text = name
                            self.surnameText.text = surname
                        }
                    }
                }
            }
        })
        
    }



}
