//
//  StudentMenuController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 09.06.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class StudentMenuController: UIViewController {

    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var currentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let name = snapshot.childSnapshot(forPath: "name").value as! String
            let surname = snapshot.childSnapshot(forPath: "surname").value as! String
            let numbers = snapshot.childSnapshot(forPath: "number").value as! String
            
            self.navigationItem.title = numbers + ": " + surname + " " + name
        })
        ref.child("current").observeSingleEvent(of: .value, with: { (snapshot) in
            let first = snapshot.childSnapshot(forPath: "first").value as! Int
            let second = snapshot.childSnapshot(forPath: "second").value as! Int
            let season = snapshot.childSnapshot(forPath: "season").value as! String
            
            self.currentLabel.text = String(first) + "/" + String(second) + " " + season
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButton(_ sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginScene")
            self.present(vc, animated: false, completion: nil)
        }

    }

}
