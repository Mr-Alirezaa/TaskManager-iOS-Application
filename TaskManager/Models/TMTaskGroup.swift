//
//  TMTaskGroup.swift
//  TaskManager
//
//  Created by Alireza Asadi on 20/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

let date = Date()


struct TMTaskGroup: Codable {
    var id: Int
    var name: String
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt
        case updatedAt
    }
}
