//
//  LoginViewController.swift
//  TaskManager
//
//  Created by Alireza Asadi on 28/2/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let connectionManager = ConnectionManager.default
    
    @IBOutlet weak var emailTextField: TMTextField!
    @IBOutlet weak var passwordTextField: TMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        print("----> back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        print("textField: --- email: \(emailTextField.text!), pass: \(passwordTextField.text!)")
//        var resultUser: User?
        connectionManager.login(username: emailTextField.text!, password: passwordTextField.text!) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    print(err)
                case .success(let user):
                    print(user)
                    let nextViewController = self?.storyboard?.instantiateViewController(withIdentifier: "firstAfterLogin")
                    self?.navigationController?.pushViewController(nextViewController!, animated: true)
                }
            }
        }
//        print("Before return")
//        if resultUser != nil { return true }
//        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
}
