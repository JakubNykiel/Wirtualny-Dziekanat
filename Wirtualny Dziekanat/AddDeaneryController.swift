//
//  AddDeaneryController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 06.10.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class AddDeaneryController: UIViewController {

    var tableResult:String!
    var keyResult:String!
    var type = "Dziekanat"
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var facultyResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        facultyResult.text = tableResult
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addDeanery(_ sender: AnyObject) {
        
    }

}
