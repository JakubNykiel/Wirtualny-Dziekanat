//
//  DziekanatMenuController.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 14.09.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class DziekanatMenuController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var field:Bool!
    
    @IBOutlet weak var aboutSubjectButton: UIButton!
    @IBOutlet weak var subjectButton: UIButton!
    @IBOutlet weak var currentLabel: UILabel!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
        if(subjectButton != nil)
        {
//            subjectButton.layer.borderWidth = 3
//            subjectButton.layer.borderColor = UIColor.black.cgColor
//            
//            aboutSubjectButton.layer.borderWidth = 3
//            aboutSubjectButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
    
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["j.nykiel93@gmail.com"])
//        mailComposerVC.setSubject("Sending you an in-app e-mail...")
//        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
