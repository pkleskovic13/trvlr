//
//  ForgotPasswordViewController+UI.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/6/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit

extension ForgotPasswordViewController {
    func setupEmailTextField() {
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        
        emailContainerView.layer.cornerRadius = 3
        emailContainerView.clipsToBounds = true
        
        emailTextField.borderStyle = .none
        emailTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func setupResetButton() {
         resetButton.setTitle("Reset password", for: UIControl.State.normal)
         resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
         resetButton.backgroundColor = UIColor.black
         resetButton.layer.cornerRadius = 5
         resetButton.clipsToBounds = true
         resetButton.setTitleColor(.white, for: UIControl.State.normal)
     }
    
    
}
