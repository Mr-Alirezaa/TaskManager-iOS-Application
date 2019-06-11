//
//  GroupNameViewController.swift
//  TaskManager
//
//  Created by Alireza Asadi on 21/3/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class GroupNameViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var groupNameTextField: TMTextField!
    
    var initialGroupName: String?
    var isEditingMode: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = initialGroupName {
            instructionLabel.text = "نام جدید را انتخاب کنید."
            groupNameTextField.text = name
        }
    }
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
    }
}
