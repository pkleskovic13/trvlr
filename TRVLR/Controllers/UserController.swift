//
//  UserController.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/4/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//
//  FAIR DISCLAIMER: Written by hand but taken from
//  https://www.iosapptemplates.com/blog/swift-programming/firebase-swift-tutorial-login-registration-ios

import UIKit
import FirebaseAuth

// MARK: Pitat Klaru jeli ovo vise potrebno?
class FirebaseAuthManager {
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                completionBlock(true)
            } else {
                print(error as Any)
                completionBlock(false)
            }
        }
    }
    
    func logIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
}
