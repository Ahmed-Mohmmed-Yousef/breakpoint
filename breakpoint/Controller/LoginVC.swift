//
//  LoginVC.swift
//  breakpoint
//
//  Created by Ahmed on 7/29/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: InsetTextField!
    @IBOutlet weak var passwordTF: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.delegate = self
        passwordTF.delegate = self
    }
    

    @IBAction func signInWasPressed(_ sender: UIButton) {
        if emailTF.text != nil && passwordTF.text != nil{
            AuthService.instance.loginUser(withEmial: emailTF.text!, Password: passwordTF.text!) { (success, error) in
                if success{
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: error?.localizedDescription ))
                }
                
                AuthService.instance.registerUSer(withEmial: self.emailTF.text!, Password: self.passwordTF.text!, creationCompletion: { (success, regError) in
                    if success{
                        AuthService.instance.loginUser(withEmial: self.emailTF.text!, Password: self.passwordTF.text!, loginCompletion: { (success, nil) in
                            print("Successfully register")
                            self.dismiss(animated: true, completion: nil)
                        })
                    } else {
                        print(String(describing: error?.localizedDescription ))
                    }
                })
            }
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
    }
}

extension LoginVC: UITextFieldDelegate{
    
}
