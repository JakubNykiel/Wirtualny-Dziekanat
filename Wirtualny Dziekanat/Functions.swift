//
//  Functions.swift
//  Wirtualny Dziekanat
//
//  Created by Jakub Nykiel on 09.06.2016.
//  Copyright © 2016 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit

struct Functions
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
}
