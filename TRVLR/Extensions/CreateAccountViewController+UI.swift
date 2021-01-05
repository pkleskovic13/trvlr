//
//  CreateAccountViewController+UI.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/6/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit

extension CreateAccountViewController {
    
    func setupHeaderTitle() {
        let title = "Create a new account"
        let subtitle = "\n\nSome text here"
        /* MARK: remove this shit !*/
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black])
        
        let attributedSubtitle = NSMutableAttributedString(string: subtitle, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.45)])
        
        attributedText.append(attributedSubtitle)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
    }
    
    func setupOrLabel() {
        orLabel.text = "Or"
        orLabel.font = UIFont.systemFont(ofSize: 16)
        orLabel.textColor = UIColor(white: 0, alpha: 0.45)
        orLabel.textAlignment = .center
    }
    
    func setupTermsLabel() {
        let attributedTermsText = NSMutableAttributedString(string: "By clicking \"Create a new account\" you agree to our ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        let attributedSubTermsText = NSMutableAttributedString(string: "Terms of Service.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        attributedTermsText.append(attributedSubTermsText)
        
        termsOfServiceLabel.numberOfLines = 0
        termsOfServiceLabel.attributedText = attributedTermsText
    }
    
    func setupFacebookButton() {
        loginFacebookButton.setTitle("Sign in with Facebook", for: UIControl.State.normal)
        loginFacebookButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginFacebookButton.backgroundColor = UIColor(displayP3Red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        loginFacebookButton.layer.cornerRadius = 5
        loginFacebookButton.clipsToBounds = true
        
        loginFacebookButton.setImage(UIImage(named: "icon-facebook") , for: UIControl.State.normal)
        loginFacebookButton.imageView?.contentMode = .scaleAspectFit
        loginFacebookButton.tintColor = .white
        loginFacebookButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
    }
    
    func setupGoogleButton() {
        loginGoogleButton.setTitle("Sign in with Google", for: UIControl.State.normal)
        loginGoogleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginGoogleButton.backgroundColor = UIColor(displayP3Red: 223/255, green: 74/255, blue: 50/255, alpha: 1)
        loginGoogleButton.layer.cornerRadius = 5
        loginGoogleButton.clipsToBounds = true
        
        loginGoogleButton.setImage(UIImage(named: "icon-google") , for: UIControl.State.normal)
        loginGoogleButton.imageView?.contentMode = .scaleAspectFit
        loginGoogleButton.tintColor = .white
        loginGoogleButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: -35, bottom: 12, right: 0)
    }
    
    func setupCreateAccountButton() {
        createAccountButton.setTitle("Create a new account", for: UIControl.State.normal)
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        createAccountButton.backgroundColor = UIColor.black
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.clipsToBounds = true
    }
}


