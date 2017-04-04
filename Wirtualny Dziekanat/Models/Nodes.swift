//
//  Nodes.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 04.04.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation

class Nodes {
    enum mainNodes: String{
        case current = "current"
        case faculty = "faculty"
        case fields = "fields"
        case grades = "grades"
        case semester = "semester"
        case classes = "subject-classes"
        case type = "subject-type"
        case subjects = "subjects"
        case users = "users"
    }
    enum facultyNodes: String {
        case name = "name"
        case id = "id_faculty"
        case users = "users"
    }
    enum usersNodes: String{
        case type = "account_type"
        case email = "email"
        case faculty = "faculty"
        case fields = "fields"
        case name = "name"
        case number = "number"
        case semester = "semester"
        case classes = "subject-classes"
        case subjects = "subjects"
        case surname = "surname"
        case title = "title"
    }
}
