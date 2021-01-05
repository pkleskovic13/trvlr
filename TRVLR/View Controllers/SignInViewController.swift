//
//  SignInViewController.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/6/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setupTitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupLogInButton()
        setupSignUpButton()
    }
    
    @IBAction func dismssAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonIsTapped(_ sender: Any) {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code){
                self.createAlert(field: "\(error.localizedDescription )", isNotError: false)
            } else {
                guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
                sceneDelegate.manageVC()
            }
        })
    }
}
