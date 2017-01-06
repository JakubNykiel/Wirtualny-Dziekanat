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
                    ref.child("fields").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in
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
        ref.child("users").child(userID).child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
            if let subjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for subject in subjects
                {
                    ref.child("subjects").child(subject.key).observeSingleEvent(of: .value, with: { (field) in
                        let fieldID = field.childSnapshot(forPath: "id_field").value as! String
                        
                        ref.child("fields").child(fieldID).observeSingleEvent(of: .value, with: { (fieldName) in
                            let name = fieldName.childSnapshot(forPath: "name").value as! String
                            dict[fieldID] = name
                            completion(dict)
                            dict.removeAll()
                        })
                    })
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
        var classesI = 0
        
        ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                let counterClasses = snapshots.count
                for snap in snapshots
                {
                    idSubject = snap.childSnapshot(forPath: "id_subject").value as! String
                    let key = snap.key
                    if(subject == idSubject)
                    {
                        self.removeClasses(classes: key)
                        classesI = classesI + 1
                        
                    }
                    else
                    {
                        classesI = classesI + 1
                    }
                }
                if(counterClasses == classesI)
                {
                    ref.child("subjects").child(subject).removeValue()
                    
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
        var i = 0
        
        ref.child("subject-classes").child(classes).observeSingleEvent(of: .value, with: { (snapshot) in
            let lecturer = snapshot.childSnapshot(forPath: "id_lecturer").value as! String
            let idSub = snapshot.childSnapshot(forPath: "id_subject").value as! String
            ref.child("users").child(lecturer).child("subject-classes").child(classes).removeValue()
            ref.child("users").child(lecturer).child("subjects").child(idSub).observeSingleEvent(of: .value, with: { (lecturerInfo) in
                let myVal = lecturerInfo.value as! Int
                
                if( myVal < 2)
                {
                    ref.child("users").child(lecturer).child("subjects").child(idSub).removeValue()
                }
                else
                {
                    ref.child("users").child(lecturer).child("subjects").updateChildValues([idSub: lecturerInfo.value as! Int - 1])
                }
            })
            
            ref.child("subject-classes").child(classes).child("users").observeSingleEvent(of: .value, with: { (subCla) in
                if let users = subCla.children.allObjects as? [FIRDataSnapshot] {
                    let counter = users.count
                    for user in users
                    {
                        ref.child("grades").observeSingleEvent(of: .value, with: { (gradeInfo) in
                            if let grades = gradeInfo.children.allObjects as? [FIRDataSnapshot] {
                                for grade in grades
                                {
                                    let gradeClasses = grade.childSnapshot(forPath: "id_classes").value as! String
                                    if(gradeClasses == classes)
                                    {
                                        ref.child("grades").child(grade.key).removeValue()
                                        ref.child("users").child(user.key).child("grades").child(grade.key).removeValue()
                                    }
                                }
                            }
                        })
                        ref.child("users").child(user.key).child("subject-classes").child(classes).removeValue()
                        ref.child("users").child(user.key).child("subjects").child(idSub).observeSingleEvent(of: .value, with: { (subInfo) in
                            if((subInfo.value as! Int ) < 2)
                            {
                                ref.child("users").child(user.key).child("subjects").child(idSub).removeValue()
                                ref.child("subjects").child(idSub).removeValue()
                                i = i + 1
                            }
                            else
                            {
                                ref.child("users").child(user.key).child("subjects").updateChildValues([idSub: subInfo.value as! Int - 1])
                                i = i + 1
                            }
                            if(i == counter)
                            {
                                ref.child("subject-classes").child(classes).removeValue()
                            }
                        })
                    }
                }
            })
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
    
    func nextSemester()
    {
        var semesterValue = ""
        var semesterValueInt:Int!
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let acc = snap.childSnapshot(forPath: "account_type").value as! String
                    if(acc == "Student")
                    {
                        ref.child("users").child(snap.key).child("fields").observeSingleEvent(of: .value, with: { (fieldInfo) in
                            if let fields = fieldInfo.children.allObjects as? [FIRDataSnapshot] {
                                for field in fields
                                {
                                    let myNumber = field.value as! String
                                    semesterValueInt = Int(myNumber)! + 1
                                    semesterValue = String(semesterValueInt)
                                    let userRef = ref.child("users").child(snap.key)
                                    if(Int(myNumber) == 7 || Int(myNumber) == 10)
                                    {
                                        self.removeStudent(user: snap.key, field: field.key, semester: myNumber)
                                    }
                                    else
                                    {
                                        userRef.child("fields").updateChildValues([field.key:semesterValue])
                                        userRef.child("semester").updateChildValues([semesterValue:true])
                                        userRef.child("semester").child(myNumber).removeValue()
                                        
                                        ref.child("semester").child(myNumber).child("users").child(snap.key).removeValue()
                                        ref.child("semester").child(semesterValue).child("users").updateChildValues([snap.key:true])
                                        
                                        userRef.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
                                            if let subjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                                for subject in subjects
                                                {
                                                    ref.child("subjects").child(subject.key).child("users").child(snap.key).removeValue()
                                                    userRef.child("subjects").child(subject.key).removeValue()
                                                    // usuwanie zajec z usera oraz userow z zajec
                                                    ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
                                                        if let classes = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                                            for item in classes
                                                            {
                                                                let idSubject = item.childSnapshot(forPath: "id_subject").value as! String
                                                                let semester = item.childSnapshot(forPath: "semester").value as! String
                                                                if(idSubject == subject.key && semester == semesterValue)
                                                                {
                                                                    ref.child("subject-classes").child(item.key).child("users").child(snap.key).removeValue()
                                                                    userRef.child("subject-classes").child(item.key).removeValue()
                                                                }
                                                            }
                                                        }
                                                    })
                                                }
                                            }
                                        }) // koneic usuwania
                                        
                                        ref.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
                                            if let subjects = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                                for subject in subjects
                                                {
                                                    let currentSubject = subject.childSnapshot(forPath: "id_field").value as! String
                                                    if(currentSubject == field.key )
                                                    {
                                                        userRef.child("subjects").updateChildValues([subject.key:true])
                                                        ref.child("subjects").child(subject.key).child("users").updateChildValues([snap.key:true])
                                                        // dodac dodawanie classes
                                                        ref.child("subject-classes").observeSingleEvent(of: .value, with: { (snapshot) in
                                                            if let classes = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                                                for item in classes
                                                                {
                                                                    let idSubject = item.childSnapshot(forPath: "id_subject").value as! String
                                                                    let semester = item.childSnapshot(forPath: "semester").value as! String
                                                                    if(idSubject == subject.key && semester == semesterValue)
                                                                    {
                                                                        userRef.child("subjectclasses").updateChildValues([item.key:true])
                                                                        ref.child("subject-classes").child(item.key).child("users").updateChildValues([snap.key:true])
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                }
                                            }
                                        })
                                        
                                    }
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
}
