//
//  Assistant.swift
//  TRVLR
//
//  Created by Klara Lucianovic (RIT Student) on 12/10/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation
import UIKit

// Sanitization of special characters
extension String {
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_:'@")
        return self.filter {okayChars.contains($0) }
    }
    
    var numbers: String {
        let okayChars = Set("1234567890")
        return self.filter {okayChars.contains($0) }
    }
}

extension UIViewController {
    func createAlert(field: String, isNotError: Bool){
         var title = ""
         switch isNotError {
         case true:
             title = "Success"
         case false:
             title = "Error"
         }
         let myMessage: String = "\(field)"
        let alert = UIAlertController(title: title, message: myMessage, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)
     }
}
