//
//  GradesStudentViewController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 29.12.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit

class GradesStudentViewController: UIViewController {
    
    @IBOutlet weak var date1: UIImageView!
    @IBOutlet weak var date2: UIImageView!
    @IBOutlet weak var date3: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var lecturerLabel: UILabel!
    
    var image = ["Pusto.png","Pusto.png","Pusto.png"]
    var typeName = ""
    var subjectName = ""
    var lecturer = ""
    var grades = [Double]()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date3.image = UIImage(named: "Pusto.png")
        date2.image = UIImage(named: "Pusto.png")
        date1.image = UIImage(named: "Pusto.png")
        typeLabel.text = typeName
        subjectLabel.text = subjectName
        lecturerLabel.text = lecturer
        counter = grades.count
        for (index,item) in grades.enumerated()
        {
            imageGrade(userResult: item, index: index)
        }
        
        date3.image = UIImage(named: image[2])
        date1.image = UIImage(named: image[0])
        date2.image = UIImage(named: image[1])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageGrade(userResult: Double, index: Int)
    {
        if(userResult == 2.0)
        {
            self.image.insert("20.png", at: index)
        }
        else if(userResult == 3.0)
        {
            self.image.insert("30.png", at: index)
        }
        else if(userResult == 3.5)
        {
            self.image.insert("35.png", at: index)
        }
        else if(userResult == 4.0)
        {
            self.image.insert("40.png", at: index)
        }
        else if(userResult == 4.5)
        {
            self.image.insert("45.png", at: index)
        }
        else if(userResult == 5.0)
        {
            self.image.insert("50.png", at: index)
        }
        else
        {
            self.image.insert("Pusto.png", at: index)
        }
    }
    
    
}
