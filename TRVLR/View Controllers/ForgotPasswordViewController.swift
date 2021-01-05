//
//  ForgotPasswordViewController.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/6/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit
import FirebaseAuth
class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setupEmailTextField()
        setupResetButton()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        guard let email = self.emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil{
                self.createAlert(field: "Use the link in the eamil to reset your password", isNotError: true)
            } else {
                self.createAlert(field: "\(error?.localizedDescription ?? "Error completing request")", isNotError: false)
            }
        })
    }
}
