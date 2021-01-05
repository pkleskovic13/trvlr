//
//  ProfileTableViewController.swift
//  TRVLR
//
//  Created by Klara Lucianovic (RIT Student) on 12/8/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class ProfileTableViewController: UITableViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var homeTextField: UITextField!
    @IBOutlet weak var travelDestinationTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var isTravelerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var interestedInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    var image: UIImage? = nil
    var databaseRef = Database.database().reference().child("users")
    let storageReference = Storage.storage().reference(forURL: "gs://trvlr-bd030.appspot.com/")
    let ERR_TEMPLATE = "Please review your "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserImage()
        fetchUser { (response) in
            guard let user = response.user else {
                return
            }
            
            let travel: Int = user.traveler == true ? 1 : 0
            let interest: Int = user.lookingFor.segment
            let gender: Int = user.gender.segment
            
            self.setFields(profileImageUrl: user.profileImageUrl, username: user.username, age: user.age, homeLocation: user.homeLocation, travelDestination: user.currentTravelDestination, about: user.about, traveler: travel, interest: interest, gender: gender)
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setFields(profileImageUrl: String, username: String, age: String, homeLocation: String, travelDestination: String, about: String, traveler: Int, interest: Int, gender: Int){
        userImage.kf.setImage(with: URL(string: profileImageUrl))
        usernameTextField.text = username
        ageTextField.text = age
        homeTextField.text = homeLocation
        travelDestinationTextField.text = travelDestination
        aboutTextView.text = about

        isTravelerSegmentedControl.selectedSegmentIndex = traveler
        interestedInSegmentedControl.selectedSegmentIndex = interest
        genderSegmentedControl.selectedSegmentIndex = gender
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
            sceneDelegate.manageVC()
        } catch {
            createAlert(field: "error logging out", isNotError: false)
            return
        }
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: UIButton) {
        updateUser { (true) in
            self.createAlert(field: "UPDATED", isNotError: true)
            return true
        }
    }
    
    func fetchUser(completion: @escaping (AsyncUserResponse)-> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        databaseRef.child(userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let rawData = snapshot.value else { return }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: rawData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let model = try decoder.decode(User.self, from: data)
                completion(AsyncUserResponse(user: model))
            } catch {
                print(error)
                completion(AsyncUserResponse(error: error))
            }
        }) { error in
            print(error)
            completion(AsyncUserResponse(error: error))
        }
    }
    
    func updateUser(completion: @escaping(Bool) -> Bool){
        /*
         MARK: refactor heavily
         */
        self.view.endEditing(true)
        // self.validateFields()
        
        image = userImage.image
        guard let imageSelected = self.image else {
            createAlert(field: "\(ERR_TEMPLATE)image", isNotError: false)
            return
        }
        guard let user = Auth.auth().currentUser else { return }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else { return }
        
        if validateFields() {
            guard let username = self.usernameTextField.text?.stripped else { return }
            guard let age = ageTextField.text?.numbers else { return }
            guard let about = aboutTextView.text?.stripped else { return }
            guard let travelDestination = travelDestinationTextField.text?.stripped else { return }
            guard let homeTown = homeTextField.text?.stripped else { return }
            let isTraveler: Bool = isTravelerSegmentedControl.selectedSegmentIndex == 1 ? true : false
            let gender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)?.lowercased()
            let interest = interestedInSegmentedControl.titleForSegment(at: interestedInSegmentedControl.selectedSegmentIndex)?.lowercased()
            
            let storageProfileReference = storageReference.child("profile").child(user.uid)
            
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
                        let dict: Dictionary<String, Any> = [
                            "uid": user.uid,
                            "email": user.email as Any,
                            "username": username,
                            "profileImageUrl": metaImageUrl,
                            "about": about,
                            "age": age,
                            "traveler": isTraveler,
                            "homeLocation": homeTown,
                            "currentTravelDestination": travelDestination,
                            "gender": gender ?? "male",
                            "lookingFor": interest ?? "both"
                        ]
                        
                        DataManager.shared.ref.child("users").child(user.uid).setValue(dict) {
                            (error:Error?, ref:DatabaseReference) in
                            if let error = error {
                                self.createAlert(field: "Data could not be saved.", isNotError: false)
                                print("Data could not be saved: \(error).")
                            } else {
                                self.createAlert(field: "Data saved successfully!", isNotError: false)
                            }
                        }
                    }
                })
            })
        }
    }
    
    func  validateInt(string: String) -> Bool{
        let result =  Int(string) != nil
        return result
    }
    
    func validateFields() -> Bool{
        guard let username = self.usernameTextField.text?.stripped else { return false }
        guard let age = ageTextField.text?.numbers else { return false }
        guard let about = aboutTextView.text?.stripped else { return false }
        guard let homeTown = homeTextField.text?.stripped else { return false }
        
        
        if username.isEmpty && homeTown.isEmpty && about.isEmpty && age.isEmpty{
            createAlert(field: "\(ERR_TEMPLATE)information", isNotError: false)
            return false
        } else if username.isEmpty {
            createAlert(field: "\(ERR_TEMPLATE)user name", isNotError: false)
            return false
        } else if age.isEmpty {
            createAlert(field: "\(ERR_TEMPLATE)age", isNotError: false)
            return false
        } else if homeTown.isEmpty {
            createAlert(field: "\(ERR_TEMPLATE)hometown", isNotError: false)
            return false
        }
        return true
    }
}
