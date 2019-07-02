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
    var taskName: String
    var dueDate: String
    var doneStatus: Bool
    var groupId: Int
    var createdAt: String
    var updatedAt: String

    var taskDescription: String?
}

extension TMTask: CustomStringConvertible {
    var description: String {
        return """

        --------------------------------------------
        Task with id: \(self.id),
        name: \(self.taskName),
        createdAt: \(self.createdAt),
        updatedAt: \(self.updatedAt),
        doneStatus: \(doneStatus),
        groupId: \(self.groupId)
        --------------------------------------------

        """

    }


}

extension TMTask: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case taskName
        case dueDate = "executionTime"
        case doneStatus
        case createdAt
        case updatedAt
        case taskDescription
        case groupId
    }
}
