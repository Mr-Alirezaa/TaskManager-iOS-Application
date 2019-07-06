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
    lazy var dataSource = TMTasksDataSource(ofGroup: taskGroup)

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.delegate = self
        dataSource.fetchTasks()
        
    }
}

extension TaskListViewController: TMTasksDataSourceDelegate {
    func tasksUpdated(_ dataSource: TMTasksDataSource) {
        self.dataSource = dataSource
        self.tableView.reloadData()
    }


}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if !dataSource.unfinishedTasks.isEmpty {
                return dataSource.unfinishedTasks.count
            } else {
                return dataSource.finishedTasks.count
            }
        } else {
            return dataSource.finishedTasks.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task: TMTask
        let cell = tableView.dequeueReusableCell(withIdentifier: "task-cell") as! TaskListTableViewCell

        if indexPath.section == 0 {
            if !dataSource.unfinishedTasks.isEmpty {
                task = dataSource.unfinishedTasks[indexPath.row]
            } else {
                task = dataSource.finishedTasks[indexPath.row]
            }
        } else {
            task = dataSource.finishedTasks[indexPath.row]
        }

        cell.taskTitleLabel.text = task.taskName
        cell.task = task
        cell.delegate = dataSource
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if dataSource.finishedTasks.isEmpty || dataSource.unfinishedTasks.isEmpty {
            return 1
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        let attributes: [NSAttributedString.Key : Any] = [.font : UIFont(name: TMFonts.shabnamBold, size: 24)!,
                                                          .foregroundColor : TMColors.black]
        label.textAlignment = NSTextAlignment.right
        label.semanticContentAttribute = .forceRightToLeft
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        let text: String
        if section == 0 {
            if !dataSource.unfinishedTasks.isEmpty {
                text =  "کار های مانده"
            } else {
                text = "کارهای انجام شده"
            }
        } else {
            text = "کارهای انجام شده"
        }
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
