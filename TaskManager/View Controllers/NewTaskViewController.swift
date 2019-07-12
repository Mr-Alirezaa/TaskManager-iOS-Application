//
//  NewTaskViewController.swift
//  TaskManager
//
//  Created by Alireza Asadi on 15/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate {
    func viewDismissed()
}

class NewTaskViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var taskNameTextField: TMTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!

    let connectionManager = ConnectionManager.default

    var group: TMTaskGroup!
    var tableDataSource: TMGroupsDataSource!

    var delegate: ModalViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.calendar = Calendar(identifier: Calendar.Identifier.persian)
        datePicker.locale = Locale(identifier: "fa_IR")
        datePicker.backgroundColor = .white

        datePicker.minimumDate = Date(timeIntervalSinceNow: 0)

        datePicker.semanticContentAttribute = .forceRightToLeft

        tableDataSource = TMGroupsDataSource(withPreCheckedGroup: group)

        tableDataSource.delegate = self

        tableView.delegate = self
        tableView.dataSource = tableDataSource


    }

    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "متوجه شدم", style: .default)
        alert.addAction(okAction)

        self.present(alert, animated: true) {

            if self.datePicker.date >= Date(timeIntervalSinceNow: 10) {
                self.datePicker.setDate(self.datePicker.date.addingTimeInterval(10), animated: true)
            }
        }
    }
    @IBAction func doneButton(_ sender: UIBarButtonItem) {

        guard let selectedGroup = tableDataSource.selectedGroup else {
            showErrorAlert(title: "خطا", message: "باید یک گروه را برای این وظیفه انتخاب کنید.")
            return
        }

        guard datePicker.date >= Date(timeIntervalSinceNow: 0) else {
            showErrorAlert(title: "خطا", message: "زمان انتخابی باید بعد از این لحظه باشد.")
            return
        }

        guard !taskNameTextField.text!.isEmpty else {
            showErrorAlert(title: "خطا", message: "شما باید برای وظیفه خود یک نام انتخاب کنید.")
            return
        }

        connectionManager.addTask(name: taskNameTextField.text!, dueTime: datePicker.date, to: selectedGroup) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                    self.showErrorAlert(title: "خطا", message: "به هنگام ایجاد تسک مشکلی پیش آمده است.")
                case .success(_):
                    self.dismiss(animated: true) {
                        self.delegate?.viewDismissed()
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)

    }
}

extension NewTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let oldSelectedRow = tableDataSource.selectedRow {
            tableDataSource.setSelectedGroup(indexPath: indexPath)
            if tableDataSource.selectedRow != nil {
                tableView.reloadRows(at: [IndexPath(row: oldSelectedRow, section: 0),
                                          IndexPath(row: tableDataSource.selectedRow!, section: 0)],
                                     with: .automatic)
            } else {
                tableView.reloadRows(at: [IndexPath(row: oldSelectedRow, section: 0)], with: .automatic)
            }
        } else {
            tableDataSource.setSelectedGroup(indexPath: indexPath)
            tableView.reloadRows(at: [IndexPath(row: tableDataSource.selectedRow!, section: 0)], with: .automatic)
        }
    }
    
}

extension NewTaskViewController: TMGroupsDataSourceDelegate {
    func groupsUpdated(_ dataSource: TMGroupsDataSource) {
        tableView.reloadData()
        
        if let selectedRow = tableDataSource.selectedRow {
            tableView.scrollToRow(at: IndexPath(row: selectedRow, section: 0), at: .middle, animated: true)
        }
    }

}
