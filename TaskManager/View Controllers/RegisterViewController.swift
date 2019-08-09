//
//  RegisterViewController.swift
//  TaskManager
//
//  Created by Alireza Asadi on 28/2/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let connectionManager = ConnectionManager.default

    @IBOutlet weak var nameTextField: TMTextField!
    @IBOutlet weak var familyNameTextField: TMTextField!
    @IBOutlet weak var emailTextField: TMTextField!
    @IBOutlet weak var passwordTextField: TMTextField!
    @IBOutlet weak var passwordRepeatTextField: TMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if emailTextField.hasText && nameTextField.hasText && familyNameTextField.hasText && passwordTextField.hasText && passwordRepeatTextField.hasText {
            if !emailTextField.text!.isValidEmail {
                let alert = UIAlertController(title: "خطا در ثبت نام", message: "لطفا یک ایمیل معتبر وارد کنید.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "متوجه شدم", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            if passwordTextField.text! != passwordRepeatTextField.text! {
                let alert = UIAlertController(title: "خطا در ثبت نام", message: "رمز عبور و تکرار رمز عبور باید یکسان باشند.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "متوجه شدم", style: .default) { [weak self] (alertAction) in
                    self?.passwordTextField.text = ""
                    self?.passwordRepeatTextField.text = ""
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            let inputUser = User(email: emailTextField.text!,
                                 password: passwordTextField.text!,
                                 firstName: nameTextField.text!,
                                 lastName: familyNameTextField.text!,
                                 phoneNumber: nil, token: nil)
            
            print("input: \(inputUser)")
            
            connectionManager.register(user: inputUser) { [weak self](result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        print(user)
                        let loginViewController = self?.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                        
                        loginViewController.initialEmail = user.email
                        self?.navigationController?.pushViewController(loginViewController, animated: true)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "خطا در ثبت نام", message: "تکمیل همه فیلد های ثبت نام الزامی است.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "متوجه شدم", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
