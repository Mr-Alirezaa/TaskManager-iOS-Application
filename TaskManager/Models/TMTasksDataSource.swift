//
//  TMTasksDataSource.swift
//  TaskManager
//
//  Created by Alireza Asadi on 5/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

protocol TMTasksDataSourceDelegate {
    func tasksUpdated(_ dataSource: TMTasksDataSource)
}

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

    var delegate: TMTasksDataSourceDelegate?

    private let connectionManager = ConnectionManager.default

    init(ofGroup group: TMTaskGroup) {
        self.parentGroup = group

    }

    func fetchTasks() {
        connectionManager.fetchTasks(for: parentGroup) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(_): break
                case .success(let downloadedTasks):
                    for task in downloadedTasks {
                        let check = self.tasks.firstIndex(of: task)
                        if check == nil {
                            self.tasks.append(task)
                        }
                    }
                    self.delegate?.tasksUpdated(self)
                }
            }
        }
    }
}

extension TMTasksDataSource: TaskListTableViewCellDelegate {
    func toggledDoneStatus(_ cell: TaskListTableViewCell, task: TMTask) {
        let index = self.tasks.firstIndex(of: task)
        if let index = index {
            let oldDoneStatus = tasks[index].doneStatus
            tasks[index].doneStatus = !oldDoneStatus
            delegate?.tasksUpdated(self)
        }
    }


}
