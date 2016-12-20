//
//  Functions.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 09.06.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MessageUI

class Functions
{
    func validateEmail(_ value: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: value)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setAnimationView(_ view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
            view.isHidden = hidden
        }, completion: { _ in })
    }
    
    //wyswietlanie wydzialow
    func displayFaculty(completion: @escaping ([String:String])->()){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()!.currentUser!.uid
        var dict = [String:String]()
        
        ref.child("users").child(userID).child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    ref.child("faculty").child(snap.key).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                        dict[snap.key] = snapshot.value as? String
                        completion(dict)
                        dict.removeAll()
                    })
                }
            }
        })
        
    }
    
    //wyswietlanie kierunkow
    func displayFields(completion: @escaping ([String:String])->()){
        var ref:FIRDatabaseReference
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()!.currentUser!.uid
        var dict = [String:String]()
        
        ref.child("users").child(userID).child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    ref.child("fields").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let fields = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for field in fields
                            {
                                let id_faculty = field.childSnapshot(forPath: "id_faculty").value as! String
                                if(snap.key == id_faculty)
                                {
                                    let name = field.childSnapshot(forPath: "name").value as! String
                                    dict[field.key] = name
                                    completion(dict)
                                    dict.removeAll()
                                }
                            }
                        }
                    })
                }
            }
        })
    }
    
    func displayFieldForUid(completion: @escaping ([String:String])->())
    {
        var ref:FIRDatabaseReference
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()!.currentUser!.uid
        var keys = [String]()
        var dict = [String:String]()
        ref.child("user-field").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let user = snap.childSnapshot(forPath: "id_user").value as! String
                    let fieldID = snap.childSnapshot(forPath: "id_field").value as! String
                    
                    if(user == userID && (keys.contains(fieldID)) == false)
                    {
                        keys.append(fieldID)
                        ref.child("fields").child(fieldID).observeSingleEvent(of: .value, with: { (snapshot) in
                            let name = snapshot.childSnapshot(forPath: "name").value as! String
                            dict[fieldID] = name
                            completion(dict)
                            dict.removeAll()
                        })
                    }
                }
            }
        })
        keys.removeAll()
    }
    
    /*
     * wyswietlanie prowadzacych z danego wydziału
     */
    
    func displayLecturer(completion: @escaping ([String:[String]])->()){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        var dict = [String:[String]]()
        let userID = FIRAuth.auth()!.currentUser!.uid
        var arrayLecturer = [String]()
        
        ref.child("users").child(userID).child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    ref.child("faculty").child(snap.key).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let users = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for user in users
                            {
                                ref.child("users").child(user.key).observeSingleEvent(of: .value, with: { (lecturer) in
                                    let acc_type = lecturer.childSnapshot(forPath: "account_type").value as! String
                                    if(acc_type == "Prowadzący")
                                    {
                                        let name = lecturer.childSnapshot(forPath: "name").value as! String
                                        let title = lecturer.childSnapshot(forPath: "title").value as! String
                                        let surname = lecturer.childSnapshot(forPath: "surname").value as! String
                                        
                                        arrayLecturer.append(title)
                                        arrayLecturer.append(name)
                                        arrayLecturer.append(surname)
                                        
                                        dict[user.key] = arrayLecturer
                                        completion(dict)
                                        dict.removeAll()
                                        arrayLecturer.removeAll()
                                    }
                                })
                            }
                        }
                    })
                }
            }
        })
        
    }
    
    
    /*
     *
     *USUWANIE PRZEDMIOTU
     */
    func removeSubject(subject: String){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        var idSubject = ""
        
        ref.child("subjects").child(subject).removeValue()
        
        ref.child("subjects").child(subject).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for user in snapshots
                {
                    ref.child("users").child(user.key).child("subjects").child(subject).removeValue()
                }
            }
        })
        
        ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    idSubject = snap.childSnapshot(forPath: "id_subject").value as! String
                    let key = snap.key
                    if(subject == idSubject)
                    {
                        self.removeClasses(classes: key)
                    }
                }
            }
        })
    }
    /*
     *
     *USUWANIE ZAJEC
     */
    func removeClasses(classes: String){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        ref.child("subject-classes").child(classes).observeSingleEvent(of: .value, with: { (snapshot) in
            let lecturer = snapshot.childSnapshot(forPath: "id_lecturer").value as! String
            ref.child("users").child(lecturer).child("subject-classes").child(classes).removeValue()
            ref.child("subject-classes").child(classes).removeValue()
        })
        ref.child("subject-classes").child(classes).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            if let users = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for user in users
                {
                    ref.child("users").child(user.key).child("subject-classes").child(classes).removeValue()
                }
            }
        })
    }
    /*
     *
     *USUWANIE Dziekanatu
     */
    func removeDeanery(user: String){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        var counter = 0
        var i = 0
        
        ref.child("users").child(user).child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                counter = snapshots.count
                for snap in snapshots
                {
                    ref.child("faculty").child(snap.key).child("users").child(user).removeValue()
                    i = i+1
                }
                if(counter == i)
                {
                    ref.child("users").child(user).updateChildValues(["email": ""])
                    ref.child("users").child(user).child("faculty").removeValue()
                }
            }
        })
        
        
    }
    /*
     *
     *USUWANIE Studenta
     */
    
    
    //do poprawki. jakis if czy wiecej niz jeden kierunek cos takiego co rozrozni mi
    func removeStudent(user: String, field: String, semester: String){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child(user).child("fields").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                if(snapshots.count > 1)
                {
                    ref.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let subjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for subject in subjects
                            {
                                let idField = subject.childSnapshot(forPath: "id_field").value as! String
                                if(idField == field)
                                {
                                    ref.child("subjects").child(subject.key).child("users").child(user).removeValue()
                                    ref.child("users").child(user).child("subjects").child(subject.key).removeValue()
                                    ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
                                        if let classes = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                            for item in classes
                                            {
                                                let idSub = item.childSnapshot(forPath: "id_subject").value as! String
                                                if(subject.key == idSub)
                                                {
                                                    ref.child("subject-classes").child(item.key).child("users").child(user).removeValue()
                                                    ref.child("users").child(user).child("subject-classes").child(item.key).removeValue()
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    })
                        ref.child("fields").child(field).child("users").child(user).removeValue()
                        ref.child("users").child(user).child("fields").child(field).removeValue()
                }
                else
                {
                    ref.child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        ref.child("users").child(user).updateChildValues(["number": "","email": ""])
                    })
                    ref.child("users").child(user).child("subjects").removeValue()
                    ref.child("users").child(user).child("subject-classes").removeValue()
                }
                //jesli wiecej wydzialow
                ref.child("users").child(user).child("faculty").observeSingleEvent(of: .value, with: { (fac) in
                    if let allFaculty = fac.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots
                        {
                            if(allFaculty.count > 1)
                            {
                                ref.child("faculty").child(snap.key).child("users").child(user).removeValue()
                                ref.child("users").child(user).child("faculty").child(snap.key).removeValue()
                            }
                        }
                    }
                })
                
            }
        })
        
    }
    
    /*
     *
     *USUWANIE Prowadzacego
     */
    func removeLecturer(user: String){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child(user).child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    ref.child("faculty").child(snap.key).child("users").child(user).removeValue()
                    ref.child("users").child(user).updateChildValues(["email": ""])
                    ref.child("users").child(user).child("faculty").removeValue()
                }
            }
        })
        ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let lecturer = snap.childSnapshot(forPath: "id_lecturer").value as! String
                    if(user == lecturer)
                    {
                        ref.child("subject-classes").child(snap.key).updateChildValues(["id_lecturer":""])
                    }
                }
            }
        })

    }
    
    /*
     * Ładowanie userów
     */
    
    /*
     * animacja ladowania
     */
    var currentOverlay : UIView?
    
    func show() {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
        }
        show(currentMainWindow)
    }
    
    func show(_ loadingText: String) {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
        }
        show(currentMainWindow, loadingText: loadingText)
    }
    
    func show(_ overlayTarget : UIView) {
        show(overlayTarget, loadingText: nil)
    }
    
    func show(_ overlayTarget : UIView, loadingText: String?) {
        
        hide()
        
        
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubview(toFront: overlay)
        
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicator.center = overlay.center
        indicator.startAnimating()
        overlay.addSubview(indicator)
        
        
        if let textString = loadingText {
            let label = UILabel()
            label.text = textString
            label.textColor = UIColor.white
            label.sizeToFit()
            label.center = CGPoint(x: indicator.center.x, y: indicator.center.y + 30)
            overlay.addSubview(label)
        }
        
        // Animate the overlay to show
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.5
        UIView.commitAnimations()
        
        currentOverlay = overlay
    }
    
    func hide() {
        if currentOverlay != nil {
            UIView.animate(withDuration: 0.5, animations: {
                self.currentOverlay?.alpha = 0
            }) { _ in
                self.currentOverlay?.removeFromSuperview()
            }
            //UIView.beginAnimations(nil, context: nil)
            //UIView.setAnimationDuration(3)
            //self.currentOverlay?.alpha = 0
            //UIView.commitAnimations()
            //currentOverlay =  nil
        }
    }
    func animate(cell:UITableViewCell) {
        let view = cell.backgroundView
        view?.layer.opacity = 0.1
        view?.backgroundColor = UIColor.black
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: { () -> Void in
            view?.layer.opacity = 1
        }, completion: nil)
    }
    
}
