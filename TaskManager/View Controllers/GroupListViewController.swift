//
//  GroupListViewController.swift
//  TaskManager
//
//  Created by Alireza Asadi on 19/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController {
    
    var user: User?
    var connectionManager = ConnectionManager.default
    
    var taskGroups = [TMTaskGroup]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc func addTaskGroupButtonTapped(sender: UIButton!) {
        let groupNameViewController = self.storyboard?.instantiateViewController(withIdentifier: "group-name-view-controller") as! GroupNameViewController
        groupNameViewController.isEditingMode = false

        self.navigationController?.pushViewController(groupNameViewController, animated: true)
    }
    
    @objc func fetchTaskGroups(_ sender: Any) {
        fetchTaskGroups()
    }
    
    func fetchTaskGroups() {
        connectionManager.fetchTaskGroups(for: User.test) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let groups):
                    self.taskGroups = groups
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
                self.tableView.refreshControl?.endRefreshing()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchTaskGroups()

        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(fetchTaskGroups(_:)), for: .valueChanged)
        tableView.refreshControl = refreshView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        fetchTaskGroups()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cell-tap" {
            if let indexPath = tableView.indexPathForSelectedRow {
                segue.destination.title = taskGroups[indexPath.row].name
            }
            if #available(iOS 11.0, *) {
                segue.destination.navigationItem.largeTitleDisplayMode = .never
            }
        }
    }
}

extension GroupListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return taskGroups.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "add-task-group")
            cell.semanticContentAttribute = .forceRightToLeft
            
            let button = UIButton(type: .contactAdd)
            button.addTarget(self, action: #selector(addTaskGroupButtonTapped(sender:)), for: .touchUpInside)
            
            button.semanticContentAttribute = .forceRightToLeft
            
            let attributes = [NSAttributedString.Key.font : UIFont(name: TMFonts.shabnamMedium, size: 15)!]
            button.setAttributedTitle(NSAttributedString(string: "  اضافه کردن گروه جدید", attributes: attributes), for: .normal)
            
            cell.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
            button.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0).isActive = true
            button.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true
            button.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "task-group-cell") as! TMGroupTableViewCell
        cell.groupTitleLabel.text = taskGroups[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return .none
        }
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (contextualAction, view, completrionHandler) in
            let taskToDelete = self?.taskGroups[indexPath.row]
            DispatchQueue.global(qos: .background).async {
                self?.connectionManager.deleteTaskGroup(taskGroup: taskToDelete!) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            completrionHandler(true)
                            self?.taskGroups.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                        case .failure(_):
                            completrionHandler(false)
                        }
                    }
                }
            }
        }
        deleteAction.image = UIImage(named: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: nil) { (contextualAction, view, completrionHandler) in
            let groupNameViewController = self.storyboard?.instantiateViewController(withIdentifier: "group-name-view-controller") as! GroupNameViewController
            groupNameViewController.taskGroup = self.taskGroups[indexPath.row]
            groupNameViewController.isEditingMode = true
            
            self.navigationController?.pushViewController(groupNameViewController, animated: true)
        }
        editAction.image = UIImage(named: "edit")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
         return .none
    }

}
