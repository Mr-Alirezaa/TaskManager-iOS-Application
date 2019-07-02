//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by Alireza Asadi on 3/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {

    let connectionManager = ConnectionManager.default

    var taskGroup: TMTaskGroup!
    var tasks = [TMTask]()
    var dataSource = TMTasksDataSource()

    @IBOutlet weak var tableView: UITableView!

    private func fetchTasks() {
        connectionManager.fetchTasks(for: taskGroup) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error): print(error)
                case .success(let tasks):
                    self.tasks = tasks
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchTasks()
        
    }
}


extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "task-cell") as! TaskListTableViewCell
        cell.taskTitleLabel.text = task.taskName
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "کار های مانده"
    }


}
