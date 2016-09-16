//
//  DziekanatMenuController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 09.06.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import DropDown
import Firebase

class DziekanatAddUserController: UIViewController {
    
    let myFunctions = Functions()
    let dropDownType = DropDown()

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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        ref.child("faculty").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            self.faculty = snapshot.value as! [String]
        })
        ref.child("semester").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            self.semester = snapshot.value as! [String]
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
        dropDownType.hide()
    }
    
    @IBAction func selectType(_ sender: AnyObject) {
        
        dropDownType.anchorView = dropDownTypeView
        dropDownType.dataSource = ["Student", "Prowadzący", "Dziekanat"]
        dropDownType.show()
        
        dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
            sender.setTitle(item, for: .normal)
            if(index == 0)
            {
                self.myFunctions.setAnimationView(view: self.studentContainer, hidden: false)
                self.myFunctions.setAnimationView(view: self.profContainer, hidden: true)
                self.myFunctions.setAnimationView(view: self.dziekanatContainer, hidden: true)
            }
            if(index == 1)
            {
                self.myFunctions.setAnimationView(view: self.studentContainer, hidden: true)
                self.myFunctions.setAnimationView(view: self.profContainer, hidden: false)
                self.myFunctions.setAnimationView(view: self.dziekanatContainer, hidden: true)
            }
            if(index == 2)
            {
                self.myFunctions.setAnimationView(view: self.studentContainer, hidden: true)
                self.myFunctions.setAnimationView(view: self.profContainer, hidden: true)
                self.myFunctions.setAnimationView(view: self.dziekanatContainer, hidden: false)
            }
        }
    }
    
    @IBAction func selectFaculty(_ sender: AnyObject) {
        dropDownType.anchorView = facultyView
        dropDownType.direction = .bottom
        dropDownType.dataSource = faculty
        dropDownType.show()
        
        dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
            self.resultFaculty.adjustsFontSizeToFitWidth = true
            self.resultFaculty.text = item
        }
    }
    
    @IBAction func selectField(_ sender: AnyObject) {
        
    }
    
    @IBAction func selectSemester(_ sender: AnyObject) {
        dropDownType.anchorView = semesterView
        dropDownType.direction = .bottom
        dropDownType.dataSource = semester
        dropDownType.show()
        
        dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
            self.resultSemester.text = item
        }
    }
    

}

