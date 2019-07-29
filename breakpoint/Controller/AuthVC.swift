//
//  AuthVC.swift
//  breakpoint
//
//  Created by Ahmed on 7/29/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginWithEmailBtnWasPressed(_ sender: UIButton) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: String(describing: LoginVC.self))
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func loginWithFB(_ sender: UIButton) {
    }
    @IBAction func loginWithGplus(_ sender: Any) {
    }
}
