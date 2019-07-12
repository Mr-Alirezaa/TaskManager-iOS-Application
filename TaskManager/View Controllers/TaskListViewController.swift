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

        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(refreshTasks), for: .valueChanged)
        tableView.refreshControl = refreshView
    }

    @objc private func refreshTasks() {
        dataSource.fetchTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    @IBAction func newTask(_ sender: UIButton) {
        let newTaskViewController = self.storyboard?.instantiateViewController(withIdentifier: "new-task-viewcontroller") as! NewTaskViewController
        navigationController?.modalPresentationStyle = .pageSheet
        newTaskViewController.group = taskGroup
        newTaskViewController.delegate = self
        navigationController?.present(newTaskViewController, animated: true)

    }
}

extension TaskListViewController: ModalViewControllerDelegate {
    func viewDismissed() {
        dataSource.fetchTasks()
    }

    func taskUpdated(task: TMTask) {
        dataSource.updateTask(task: task)
    }
}

extension TaskListViewController: TMTasksDataSourceDelegate {
    func singleTaskRemoved(_ dataSource: TMTasksDataSource, atIndexPath indexPath: IndexPath) {
        self.dataSource = dataSource
        self.tableView.deleteRows(at: [indexPath], with: .automatic)

        self.tableView.refreshControl?.endRefreshing()

    }

    func singleTaskUpdated(_ dataSource: TMTasksDataSource, atIndexPath indexPath: IndexPath) {
        self.dataSource = dataSource
        self.tableView.reloadRows(at: [indexPath], with: .automatic)

        self.tableView.refreshControl?.endRefreshing()
    }

    func tasksUpdated(_ dataSource: TMTasksDataSource) {
        self.dataSource = dataSource
        self.tableView.reloadData()

        self.tableView.refreshControl?.endRefreshing()
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

        cell.taskTitleLabel.text = task.name
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

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (deleteAction, view, completionHandler) in
            let newCompletionHandler: (Bool) -> Void = {
                switch $0 {
                case true:
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    completionHandler(true)
                case false:
                    completionHandler(false)
                }
            }
            self.dataSource.deleteTask(taskAtIndexPath: indexPath, completionHandler: newCompletionHandler)
        }
        deleteAction.image = UIImage(named: "trash")

        let editAction = UIContextualAction(style: .normal, title: nil) { (contextualAction, view, completrionHandler) in
            let editTaskViewController = self.storyboard?.instantiateViewController(withIdentifier: "new-task-viewcontroller") as! NewTaskViewController
            self.navigationController?.modalPresentationStyle = .pageSheet
            editTaskViewController.isEditingMode = true
            editTaskViewController.editingTask = self.dataSource.getTask(atIndexPath: indexPath)
            editTaskViewController.group = self.taskGroup
            editTaskViewController.delegate = self
            self.navigationController?.present(editTaskViewController, animated: true)
        }
        editAction.image = UIImage(named: "edit")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration

        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
