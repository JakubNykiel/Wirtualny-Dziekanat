//
//  DziekanatMenuController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 09.06.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class DziekanatAddUserController: UIViewController {
    
    let myFunctions = Functions()
//    let dropDownType = DropDown()

    @IBOutlet weak var dropDownTypeView: UIView!
    
    @IBOutlet weak var studentContainer: UIView!
    @IBOutlet weak var profContainer: UIView!
    @IBOutlet weak var dziekanatContainer: UIView!

    @IBOutlet weak var facultyView: UIView!
    @IBOutlet weak var semesterView: UIView!
    @IBOutlet weak var fieldView: UIView!
    
    @IBOutlet weak var resultFaculty: UILabel!
    @IBOutlet weak var resultField: UILabel!
    @IBOutlet weak var resultSemester: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var numbersText: UITextField!
    @IBOutlet weak var titlesText: UITextField!
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var faculty = [String]()
    var semester = [String]()
    var student = [String:AnyObject]()
    var account_type = ""
   
    @IBOutlet weak var dziekanatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref.child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            self.faculty = snapshot.value as! [String]
        })
        ref.child("semester").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            self.semester = snapshot.value as! [String]
        })
        ref.child("student").child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            self.student = [:]
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                   let key = snap.key
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.studentContainer?.isHidden = true
        self.profContainer?.isHidden = true
        self.dziekanatContainer?.isHidden = true
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
//        dropDownType.hide()
    }
    
//    @IBAction func selectType(_ sender: AnyObject){
//        
//        dropDownType.anchorView = dropDownTypeView
//        dropDownType.dataSource = ["Student", "Prowadzący", "Dziekanat"]
//        dropDownType.show()
//        
//        dropDownType.selectionAction = { (index: Int, item: String) in
//            sender.setTitle(item, for: .normal)
//            self.account_type = item
//            if(index == 0)
//            {
//                self.myFunctions.setAnimationView(self.studentContainer, hidden: false)
//                self.myFunctions.setAnimationView(self.profContainer, hidden: true)
//                self.myFunctions.setAnimationView(self.dziekanatContainer, hidden: true)
//                
//            }
//            if(index == 1)
//            {
//                self.myFunctions.setAnimationView(self.studentContainer, hidden: true)
//                self.myFunctions.setAnimationView(self.profContainer, hidden: false)
//                self.myFunctions.setAnimationView(self.dziekanatContainer, hidden: true)
//            }
//            if(index == 2)
//            {
//                self.myFunctions.setAnimationView(self.studentContainer, hidden: true)
//                self.myFunctions.setAnimationView(self.profContainer, hidden: true)
//                self.myFunctions.setAnimationView(self.dziekanatContainer, hidden: false)
//            }
//        }
//
//    }
//    
//    @IBAction func selectFaculty(_ sender: AnyObject) {
//        dropDownType.anchorView = facultyView
//        dropDownType.direction = .bottom
//        dropDownType.dataSource = faculty
//        dropDownType.show()
//        
//        dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.resultFaculty.adjustsFontSizeToFitWidth = true
//            self.resultFaculty.text = item
//        }
//    }
//    
//    @IBAction func selectField(_ sender: AnyObject) {
//        
//    }
//    
//    @IBAction func selectSemester(_ sender: AnyObject) {
//        dropDownType.anchorView = semesterView
//        dropDownType.direction = .bottom
//        dropDownType.dataSource = semester
//        dropDownType.show()
//        
//        dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.resultSemester.text = item
//        }
//    }
//    @IBAction func addDziekanatUserButton(_ sender: AnyObject) {
//        
////        let password = "s" + numbersText.text!
//        
//
//        FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: "Test123456") { (user, error) in
//            
//            if error != nil {
//                print("Mamy błąd")
//                print(error)
//            } else {
//                
//                print(user?.uid)
//                
//                
//                let newUser = [
//                    "account_type": "Dziekanat"
//                ]
//               
//                self.ref.child("users")
//                    .child((user?.uid)!).childByAutoId().setValue(newUser)
//            }
//
//        }
//        
//    }
}

