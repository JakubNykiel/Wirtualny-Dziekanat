//
//  DziekanatAddSubjectController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 20.09.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class DziekanatAddSubjectController: UIViewController {

    @IBOutlet weak var subjectText: UITextField!
    @IBOutlet weak var facultyView: UIView!
    @IBOutlet weak var semesterView: UIView!
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var facultyResult: UILabel!
    @IBOutlet weak var fieldResult: UILabel!
    @IBOutlet weak var semesterResult: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectFaculty(_ sender: AnyObject) {
    }
    @IBAction func selectField(_ sender: AnyObject) {
    }
    @IBAction func selectSemester(_ sender: AnyObject) {
    }
    

}
