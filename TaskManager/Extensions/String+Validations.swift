//
//  String+Validations.swift
//  TaskManager
//
//  Created by Alireza Asadi on 20/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        print(emailTest.evaluate(with: self))
        return emailTest.evaluate(with: self)
    }
}
