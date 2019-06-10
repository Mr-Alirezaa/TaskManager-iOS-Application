//
//  GroupListViewController.swift
//  TaskManager
//
//  Created by Alireza Asadi on 19/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: User?
    var connectionManager = ConnectionManager.default
    
    var taskGroups = [TMTaskGroup]()
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task-group-cell") as! TMGroupTableViewCell
        cell.groupTitleLabel.text = taskGroups[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "حذف") { [weak self] (rowAction, indexPath) in
            let deletedTaskGroup = self?.taskGroups.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            DispatchQueue.global(qos: .background).async {
                self?.connectionManager.deleteTaskGroup(taskGroup: deletedTaskGroup!) { (_) in
                    return
                }
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "تغییر") { (rowAction, indexPath) in
            
        }
        return [deleteAction, editAction]
    }
    
    private func fetchTaskGroups() {
        connectionManager.fetchTaskGroups(for: User.test) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let groups):
                    self.taskGroups = groups
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchTaskGroups()
    }
}
