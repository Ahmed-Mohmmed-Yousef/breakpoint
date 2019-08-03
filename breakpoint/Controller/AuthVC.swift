//
//  AuthVC.swift
//  breakpoint
//
//  Created by Ahmed on 7/29/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthVC: UIViewController, GIDSignInUIDelegate, LoginButtonDelegate {
    

    let loginManeger = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func loginWithEmailBtnWasPressed(_ sender: UIButton) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: String(describing: LoginVC.self))
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func loginWithFB(_ sender: UIButton) {
//        loginManeger.logIn(permissions: ["email"], from: self) { (result, error) in
//            if error != nil {
//                return
//            } else {
//                let credintail = FacebookAuthProvider.credential(withAccessToken: (result?.token!.tokenString)!)
//                Auth.auth().signIn(with: credintail, completion: { (res, eeror) in
//                    if error != nil {
//                        return
//                    } else {
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                })
//            }
//        }
    }
    @IBAction func loginWithGplus(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // google auth
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // facebook auth
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            return
        }
        let credintial = FacebookAuthProvider.credential(withAccessToken: result!.token!.tokenString)
        Auth.auth().signIn(with: credintial) { (result, error) in
            if error != nil {
                return
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
}
