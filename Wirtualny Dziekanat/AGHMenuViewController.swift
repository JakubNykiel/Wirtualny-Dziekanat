//
//  AGHMenuViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 30.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AGHMenuViewController: UIViewController {
    
    @IBOutlet weak var currentLabel: UILabel!
    var myFunc = Functions()
    var ref: FIRDatabaseReference!
    var winter = "ZIMOWY"
    var summer = "LETNI"
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
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
    @IBAction func nextButton(_ sender: Any) {
        let alert = UIAlertController(title: "Czy jesteś pewien?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Powrót", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Usuń", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
            self.myFunc.nextSemester()
            self.ref.child("current").observeSingleEvent(of: .value, with: { (snapshot) in
                var first = snapshot.childSnapshot(forPath: "first").value as! Int
                var second = snapshot.childSnapshot(forPath: "second").value as! Int
                let season = snapshot.childSnapshot(forPath: "season").value as! String
                
                first = first + 1
                second = second + 1
                if(season == "ZIMOWY")
                {
                    self.ref.child("current").updateChildValues(["fisrt":first, "second":second,"season":self.summer])
                }
                else
                {
                    self.ref.child("current").updateChildValues(["fisrt":first, "second":second,"season":self.winter])
                }
                
            })
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginScene")
            self.present(vc, animated: true, completion: nil)
        }

    }    
}
