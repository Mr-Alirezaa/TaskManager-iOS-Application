//
//  TMTasksDataSource.swift
//  TaskManager
//
//  Created by Alireza Asadi on 5/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

public class TMTasksDataSource {

    private var tasks = [TMTask]()
    var count: Int { return tasks.count }

    var finishedTasks: [TMTask] {
        return tasks.filter { $0.doneStatus == true }
    }

    var unfinishedTasks: [TMTask] {
        return tasks.filter { $0.doneStatus == false }
    }

    var parentGroup: TMTaskGroup

//    var delegate: TMTasksDelegate

    private let connectionManager = ConnectionManager.default

    init(ofGroup group: TMTaskGroup) {
        self.parentGroup = group
//        fetchTasks()
    }

    private func fetchTasks() {
        connectionManager.fetchTasks(for: parentGroup) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(_): break
                case .success(let tasks):
                    for task in tasks {
                        let check = self.tasks.filter { $0.id == task.id }
                        if check.isEmpty {
                            self.tasks.append(task)
                        }
                    }
                }
            }
        }
    }

    private func reloadTasks() {
        fetchTasks()
    }
}
