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
    
    var initialEmail: String?
    
    @IBOutlet weak var emailTextField: TMTextField!
    @IBOutlet weak var passwordTextField: TMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if let initialEmail = initialEmail {
            emailTextField.text = initialEmail
        } else {
            let initialEmail = UserDefaults.standard.string(forKey: TMUserDefualtsKeys.lastLoginEmail)
            emailTextField.text = initialEmail
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        print("----> back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        if emailTextField.hasText && passwordTextField.hasText {
            if !emailTextField.text!.isValidEmail {
                let alert = UIAlertController(title: "خطا در ورود", message: "لطفا یک ایمیل معتبر وارد کنید.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "متوجه شدم", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            connectionManager.login(username: emailTextField.text!, password: passwordTextField.text!) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let err):
                        switch err {
                            case TMError.SignInError.userNotFound:
                                let alert = UIAlertController(title: "خطا در ورود", message: "ایمیل یا رمز عبور اشتباه است.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "متوجه شدم", style: .default) { (ـ) in
                                    self?.passwordTextField.text = ""
                                }
                                alert.addAction(okAction)
                                self?.present(alert, animated: true, completion: nil)
                                return
                            default:
                                let alert = UIAlertController(title: "خطا در ورود", message: "هنگام ورود مشکلی پیش آمده است. لطفا مجددا تلاش کنید.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "متوجه شدم", style: .default) { (ـ) in
                                    self?.passwordTextField.text = ""
                                }
                                alert.addAction(okAction)
                                self?.present(alert, animated: true, completion: nil)
                                return
                        }
                    case .success(let user):
                        DispatchQueue.main.async {
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(user.token!, forKey: TMUserDefualtsKeys.apiToken)
                            userDefaults.set(user.email, forKey: TMUserDefualtsKeys.lastLoginEmail)
                        }
                        let nextViewController = self?.storyboard?.instantiateViewController(withIdentifier: "firstAfterLogin")
                        self?.navigationController?.pushViewController(nextViewController!, animated: true)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "خطا در ورود", message: "تکمیل همه فیلد های ورود الزامی است.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "متوجه شدم", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
}
