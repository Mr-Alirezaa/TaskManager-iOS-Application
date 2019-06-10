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
        get {
            let regEx = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            return regEx?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil
        }
    }
}
