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
    func singleTaskUpdated(_ dataSource: TMTasksDataSource, atIndexPath indexPath: IndexPath)
    func singleTaskRemoved(_ dataSource: TMTasksDataSource, atIndexPath indexPath: IndexPath)

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

    func getTask(atIndexPath indexPath: IndexPath) -> TMTask? {
        if indexPath.section == 0 {
            return unfinishedTasks[indexPath.row]
        } else {
            return finishedTasks[indexPath.row]
        }
    }

    private func indexPath(for task: TMTask) -> IndexPath {
        let section: Int = task.doneStatus! ? 1 : 0
        let row: Int = task.doneStatus! ? finishedTasks.firstIndex(of: task)! : unfinishedTasks.firstIndex(of: task)!
        return IndexPath(row: row, section: section)
    }

    func updateTask(task: TMTask) {
        let index = tasks.firstIndex(of: task)
        if let index = index {
            if task.groupId != parentGroup.id {
                tasks.remove(at: index)
                delegate?.singleTaskUpdated(self, atIndexPath: indexPath(for: tasks[index]))
                return
            }
            tasks[index].name = task.name
            tasks[index].groupId = task.groupId
            tasks[index].dueDate = task.dueDate
            tasks[index].updatedAt = task.updatedAt
            delegate?.singleTaskUpdated(self, atIndexPath: indexPath(for: tasks[index]))
        }
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
                    print("delegeate: tasksUpdated gets called.")
                }
            }
        }
    }

    func deleteTask(taskAtIndexPath indexPath: IndexPath, completionHandler: @escaping (Bool) -> Void) {
        let task: TMTask
        if indexPath.section == 0 {
            task = unfinishedTasks[indexPath.row]
        } else {
            task = finishedTasks[indexPath.row]
        }
        DispatchQueue.global(qos: .background).sync {
            connectionManager.delete(task: task) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.tasks.removeAll { $0 == task }
                        completionHandler(true)
                    case .failure(_):
                        completionHandler(false)
                    }
                }
            }
        }
    }
}

extension TMTasksDataSource: TaskListTableViewCellDelegate {
    func toggledDoneStatus(_ cell: TaskListTableViewCell, task: TMTask) {
        let index = self.tasks.firstIndex(of: task)
        if let index = index {
            let oldDoneStatus = tasks[index].doneStatus!
            tasks[index].doneStatus! = !oldDoneStatus
            delegate?.tasksUpdated(self)
        }
    }


}
