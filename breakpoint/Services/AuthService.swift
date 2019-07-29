//
//  AuthService.swift
//  breakpoint
//
//  Created by Ahmed on 7/29/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import Foundation
import Firebase
class AuthService{
    static let authService = AuthService()
    
    func registerUSer(withEmial email: String, Password password: String, creationCompletion: @escaping(_ success: Bool, _ error: Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                creationCompletion(false, error)
                return
            }
            let userData: Dictionary<String, Any> = ["provider": user.providerID,
                                                     "email": user.email!]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            creationCompletion(true, nil)
        }
        
    }
    
    func loginUser(withEmial email: String, Password password: String, loginCompletion: @escaping(_ success: Bool, _ error: Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard (authResult?.user) != nil else {
                loginCompletion(false, error)
                return
            }
            loginCompletion(true, nil)
        }
    }
}
