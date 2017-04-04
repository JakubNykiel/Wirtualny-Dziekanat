//
//  Faculty.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 04.04.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase

class Faculty
{
    var ref: FIRDatabaseReference!
    let userID = FIRAuth.auth()!.currentUser!.uid
    var dict = [String:String]()
    
    let mainNodes = Nodes.mainNodes.self
    let facultyNodes = Nodes.facultyNodes.self
    let usersNodes = Nodes.usersNodes.self
    
    func displayFaculty(completion: @escaping ([String:String])->()){
        
        ref = FIRDatabase.database().reference()
        
        ref.child(mainNodes.users.rawValue).child(userID).child(usersNodes.faculty.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots
                {
                    self.ref.child(self.mainNodes.faculty.rawValue).child(snap.key).child(self.facultyNodes.name.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
                        self.dict[snap.key] = snapshot.value as? String
                        completion(self.dict)
                        self.dict.removeAll()
                    })
                }
            }
        })
        
    }
}
