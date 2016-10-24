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
        var value = ""
        
        ref.child("user-faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    
                    let fn = snap.childSnapshot(forPath: "id_faculty").value as! String
                    let sn = snap.childSnapshot(forPath: "id_user").value as! String
                    
                    if(sn == userID)
                    {
                        value = fn
                    }
                }
            }
        })
        ref.child("faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let fn = snap.childSnapshot(forPath: "id").value as! String
                    let sn = snap.childSnapshot(forPath: "name").value as! String
                    
                    if(fn == value)
                    {
                        dict[fn] = sn
                        completion(dict)
                        dict.removeAll()
                    }
                    
                }
            }
        })
    }
    
    //wyswietlanie kierunkow
    func displayFields(completion: @escaping ([String:String])->()){
        var ref:FIRDatabaseReference
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()!.currentUser!.uid
        var value = ""
        var dict = [String:String]()
        
        ref.child("user-faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let fn = snap.childSnapshot(forPath: "id_faculty").value as! String
                    let sn = snap.childSnapshot(forPath: "id_user").value as! String
                    
                    if(sn == userID)
                    {
                        value = fn
                    }
                }
            }
        })
        
        ref.child("fields").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    let fn = snap.childSnapshot(forPath: "id_faculty").value as! String
                    let sn = snap.childSnapshot(forPath: "name").value as! String
                    if(fn == value)
                    {
                        dict[snap.key] = sn
                        completion(dict)
                        dict.removeAll()
                    }
                }
                
                
            }
        })
    }
    
    /*
     * wyswietlanie prowadzacych z danego wydziału
     */
    
    func displayLecturer(completion: @escaping ([String:[String]])->()){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        var dict = [String:[String]]()
        var userKeys :[String] = [""]
        var currentFaculty = ""
        let userID = FIRAuth.auth()!.currentUser!.uid
        var arrayLecturer = [String]()
        
        ref.child("user-faculty").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                //sprawdzenie wydzialu konta
                for snap in snapshots
                {
                    let fn = snap.childSnapshot(forPath: "id_faculty").value as! String
                    let sn = snap.childSnapshot(forPath: "id_user").value as! String
                    
                    if(sn == userID)
                    {
                        currentFaculty = fn
                        break
                    }
                }
                
                //pobranie kluczy userow z wydzialem
                for snap in snapshots
                {
                    let fn = snap.childSnapshot(forPath: "id_faculty").value as! String
                    let sn = snap.childSnapshot(forPath: "id_user").value as! String
                    
                    if(fn == currentFaculty)
                    {
                        userKeys.append(sn)
                    }
                }
            }
        })
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots
                {
                    let account_type = snap.childSnapshot(forPath: "account_type").value as! String
                    let name = snap.childSnapshot(forPath: "name").value as! String
                    let surname = snap.childSnapshot(forPath: "surname").value as! String
                    let key = snap.key
                    
                    if( account_type == "Prowadzący")
                    {
                        let title = snap.childSnapshot(forPath: "title").value as! String
                        
                        arrayLecturer.append(title)
                        arrayLecturer.append(name)
                        arrayLecturer.append(surname)
                        
                        dict[key] = arrayLecturer
                        completion(dict)
                    }
                }
            }
        })
        dict.removeAll()
    }
    
    
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
            //            UIView.animate(withDuration: 0.5, animations: {
            //                self.currentOverlay?.alpha = 0
            //            }) { _ in
            //                self.currentOverlay?.removeFromSuperview()
            //            }
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.75)
            self.currentOverlay?.alpha = 0
            UIView.commitAnimations()
            currentOverlay =  nil
        }
    }
}
