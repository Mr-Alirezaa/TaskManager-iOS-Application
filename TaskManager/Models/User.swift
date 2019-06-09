//
//  User.swift
//  TaskManager
//
//  Created by Alireza Asadi on 16/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

public struct User: Codable, CustomStringConvertible {
    public var description: String {
        return "User with email: \(self.email), password: \(self.password)"
    }

    var email: String
    var password: String
    
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case phoneNumber = "phone_number"
    }
}
