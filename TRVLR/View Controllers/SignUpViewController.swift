//
//  SignUpViewController.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/6/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var fullnameContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var hometownView: UIView!
    
    var image: UIImage? = nil
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setupTitleLabel()
        setupAvatar()
        setupFullNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignUpButton()
        setupLogInButton()
        setupTextField(container: hometownView, field: hometownTextField)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        if validateFields() {
            image = avatarImage.image
            guard let imageSelected = self.image else {
                createAlert(field: "image", isNotError: false)
                return
            }
            guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else { return }
            guard let username = self.fullnameTextField.text else { return }
            guard let email = self.emailTextField.text else { return }
            guard let password = self.passwordTextField.text else { return }
            guard let hometown = self.hometownTextField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                if let user = authResult {

                    var dict: Dictionary<String, Any> = [
                        "uid": user.user.uid,
                        "email": user.user.email as Any,
                        "username": username,
                        "profileImageUrl": "",
                        "about": "This is where you say something about yourself",
                        "age": "0",
                        "traveler": false,
                        "homeLocation": hometown,
                        "currentTravelDestination": "",
                        "gender": "male",
                        "lookingFor": "both"]
                    let storageReference = Storage.storage().reference(forURL: "gs://trvlr-bd030.appspot.com/")
                    let storageProfileReference = storageReference.child("profile").child(user.user.uid)
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpg"
                    storageProfileReference.putData(imageData, metadata: metadata, completion: {
                        (StorageMetadata, error) in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                            return
                        }
                        storageProfileReference.downloadURL(completion: { (url, error) in
                            if let metaImageUrl = url?.absoluteString{
                                dict["profileImageUrl"] = metaImageUrl
                                self.databaseRef.child("users").child(user.user.uid).updateChildValues(dict, withCompletionBlock: {
                                    (error, ref) in
                                    if error == nil {
                                        print("Done")
                                    }
                                })
                            }
                        })
                    })
                } else {
                    self.createAlert(field: String(describing: error?.localizedDescription.description), isNotError: false)
                }
                guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
                sceneDelegate.manageVC()
            }
        }
    }
    
    
    //MARK: export this
    func validateFields() -> Bool{
        guard let username = self.fullnameTextField.text else { return false }
        guard let email = self.emailTextField.text else { return false }
        guard let password = self.passwordTextField.text else { return false }
        guard let hometown = self.hometownTextField.text else { return false }
        
        if username.isEmpty && email.isEmpty && password.isEmpty && hometown.isEmpty {
            createAlert(field: "information", isNotError: false)
            return false
        } else if username.isEmpty {
            createAlert(field: "user name", isNotError: false)
            return false
        } else if email.isEmpty {
            createAlert(field: "email", isNotError: false)
            return false
        } else if password.isEmpty || password.count < 6 {
            createAlert(field: "password \n (at least six characters)", isNotError: false)
            return false
        } else if hometown.isEmpty {
            createAlert(field: "hometown", isNotError: false)
            return false
        }
        return true
    }
}
