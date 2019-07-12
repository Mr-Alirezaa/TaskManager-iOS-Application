//
//  GroupNameViewController.swift
//  TaskManager
//
//  Created by Alireza Asadi on 21/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class GroupNameViewController: UIViewController {
    
    let connectionManager = ConnectionManager.default

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var groupNameTextField: TMTextField!
    
    var taskGroup: TMTaskGroup?
    var isEditingMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditingMode {
            instructionLabel.text = "نام جدید را انتخاب کنید."
            groupNameTextField.text = taskGroup?.name
        }
    }
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if groupNameTextField.hasText {
            if isEditingMode, let group = taskGroup {
                if group.name != groupNameTextField.text {
                    connectionManager.editTaskGroupName(taskGroup: group, to: groupNameTextField.text!) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .failure(_):
                                break
                            case .success(_):
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            } else {
                connectionManager.createTaskGroup(withName: groupNameTextField.text!) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(_):
                            break
                        case .success(_):
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "خطا در انتخاب اسم", message: "لطفا برای گروه یک اسم انتخال کنید.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "متوجه شدم", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
