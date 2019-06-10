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
        return """
        
        --------------------------------------------
        User with email: \(self.email),
               password: \(self.password),
              firstName: \(self.firstName ?? "-"),
               lastName: \(self.lastName ?? "-"),
            phoneNumber: \(self.phoneNumber ?? "-"),
                  token: \(self.token ?? "-").
        --------------------------------------------
        
        """
    }

    var email: String
    var password: String
    
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case phoneNumber = "phone_number"
    }
    
    // FIXME: Remove this:
    static var test: User {
        return User(email: "fck@gmail.com", password: "123456", firstName: nil, lastName: nil, phoneNumber: nil, token: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiNzYwYWM4ZWQtMzhkMy00ZjUzLWE3YjItOWFkOWIzYmRhNjRhIiwiaWF0IjoxNTM5MjUwNTg2fQ.exeb-WXsM06aWMtInkQcaoK7hKJ9NGrUpQUsHkKBdIk")
    }
}
