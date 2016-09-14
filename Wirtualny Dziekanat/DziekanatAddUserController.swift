//
//  DziekanatMenuController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 09.06.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import DropDown

class DziekanatAddUserController: UIViewController {
    
    let myFunctions = Functions()

    let dropDownType = DropDown()
    @IBOutlet weak var dropDownTypeView: UIView!
    
    @IBOutlet weak var studentContainer: UIView!
    @IBOutlet weak var profContainer: UIView!
    @IBOutlet weak var dziekanatContainer: UIView!
    

    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.resultLabel.text = item
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

}
