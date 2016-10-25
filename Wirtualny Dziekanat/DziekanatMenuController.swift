//
//  DziekanatMenuController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 14.09.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class DziekanatMenuController: UIViewController {
    
    var field:Bool!

    @IBOutlet weak var aboutSubjectButton: UIButton!
    @IBOutlet weak var subjectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(subjectButton != nil)
        {
            subjectButton.layer.borderWidth = 3
            subjectButton.layer.borderColor = UIColor.black.cgColor
            
            aboutSubjectButton.layer.borderWidth = 3
            aboutSubjectButton.layer.borderColor = UIColor.black.cgColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "whatAddSegue")
        {
            let destinationVC = segue.destination as! SelectFacultyTableViewController
            
            destinationVC.field = true
        }
        if (segue.identifier == "chooseSubject")
        {
            let destinationVC = segue.destination as! SelectFieldTableViewController
            
            destinationVC.chooseField = true
            
        }
        if (segue.identifier == "chooseClasses")
        {
            let destinationVC = segue.destination as! SelectFieldTableViewController
            
            destinationVC.chooseClasses = true
            
        }
    }
    
    @IBAction func signOutButton(_ sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginScene")
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}
