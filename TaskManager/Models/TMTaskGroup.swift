//
//  TMTaskGroup.swift
//  TaskManager
//
//  Created by Alireza Asadi on 20/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

struct TMTaskGroup: Codable, CustomStringConvertible {
    var description: String {
        return """
        
        --------------------------------------------
        Task Group with id: \(self.id),
                      name: \(self.name),
                 createdAt: \(self.createdAt),
                 updatedAt: \(self.updatedAt).
        --------------------------------------------
        
        """

    }
    
    var id: Int
    var name: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt
        case updatedAt
    }
}
