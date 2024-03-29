//
//  TMTask.swift
//  TaskManager
//
//  Created by Alireza Asadi on 3/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

struct TMTask {
    var id: Int
    var name: String
    var dueDate: String
    var doneStatus: Bool?
    var groupId: Int?
    var createdAt: String
    var updatedAt: String

    var taskDescription: String?

    mutating public func toggleDoneStatus() {
        doneStatus = !doneStatus!
    }

    
}

extension TMTask: CustomStringConvertible {
    var description: String {
        return """

        --------------------------------------------
        Task with id: \(self.id),
        name: \(self.name),
        createdAt: \(self.createdAt),
        updatedAt: \(self.updatedAt),
        doneStatus: \(doneStatus ?? false),
        groupId: \(self.groupId ?? -1)
        --------------------------------------------

        """

    }


}

extension TMTask: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "taskName"
        case dueDate = "executionTime"
        case doneStatus
        case createdAt
        case updatedAt
        case taskDescription
        case groupId
    }
}

extension TMTask: Equatable {
    static func ==(lhs: TMTask, rhs: TMTask) -> Bool {
        return lhs.id == rhs.id
    }
}
