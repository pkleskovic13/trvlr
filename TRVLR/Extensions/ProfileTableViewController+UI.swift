//
//  ProfileTableViewController+UI.swift
//  TRVLR
//
//  Created by Klara Lucianovic (RIT Student) on 12/8/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit

extension ProfileTableViewController {
    func setupUserImage() {
          userImage.layer.cornerRadius = 40
          userImage.clipsToBounds = true
          
          userImage.isUserInteractionEnabled = true
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPicker))
          userImage.addGestureRecognizer(tapGesture)
      }
    @objc func showPicker(){
         let picker = UIImagePickerController()
         picker.sourceType = .photoLibrary
         picker.allowsEditing = true
         picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
         self.present(picker, animated: true, completion: nil)
     }
    
}
extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage.image = imageSelected
            image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            userImage.image = imageOriginal
            image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
