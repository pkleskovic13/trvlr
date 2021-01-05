//
//  KolodaViewControllerDelegate.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/7/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation
import Koloda
import FirebaseAuth
import FirebaseDatabase

extension KolodaViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        // Not implemented, this method usually handles the event in which the user touches the card stack
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        if direction == SwipeResultDirection.right {
            let swipe = Swipe(user1UID: userID, user2UID: users[index].uid, swipeDirection: .right)
            DataManager.shared.pushSwipeToDatabase(swipe: swipe)
            checkForMatches(swipe: swipe) { (result) in
                if(result) {
                    self.createAlert(field: "It's a match!", isNotError: true)
                }
            }
        } else if direction == .left {
            let swipe = Swipe(user1UID: userID, user2UID: users[index].uid, swipeDirection: .left)
            DataManager.shared.pushSwipeToDatabase(swipe: swipe)
        }
    }
    

    
    func filterUserCards(unfilteredUsers: [User], allSwipes: [Swipe]) -> [User] {
        var userArray = unfilteredUsers
        let plsWork: [User] = []
        
        guard let currentUserID = DataManager.shared.userID else {
            return plsWork
        }
        
        let currentUserObject = userArray.first { (user) -> Bool in
            user.uid == currentUserID
        }
        
        guard let unwrappedUserObject = currentUserObject else { return plsWork }
        
        userArray = userArray.filter { $0.uid != currentUserID }
        
        // Checking if the user fits the town criteria
        if(currentUserObject?.traveler ?? false) {
            userArray = userArray.filter { $0.homeLocation == unwrappedUserObject.currentTravelDestination || $0.currentTravelDestination == unwrappedUserObject.currentTravelDestination }
        } else {
            userArray = userArray.filter { $0.currentTravelDestination == unwrappedUserObject.homeLocation }
        }
        
        // this checks the local user's preferences
        switch unwrappedUserObject.lookingFor {
        case .male:
            userArray = userArray.filter { $0.gender == .male }
        case .female:
            userArray = userArray.filter { $0.gender == .female }
        case .both:
            userArray = userArray.filter { $0.gender == .male || $0.gender == .female }
        }
        
        // This checks the preferences of the user that we will try matching with
        userArray = userArray.filter({ (user: User) -> Bool in
            if(unwrappedUserObject.gender == .male && user.lookingFor == .male) {
                return true
            } else if(unwrappedUserObject.gender == .female && user.lookingFor == .female) {
                return true
            } else if(user.lookingFor == .both) {
                return true
            } else {
                return false
            }
        })
        
        // Checking if the user swiped on this user before
        userArray = userArray.filter { (user: User) -> Bool in
            return !allSwipes.contains { (swipe: Swipe) -> Bool in
                return user.uid == swipe.user2UID
            }
        }
        
        return userArray
    }
    
    // This method is definitely violating DRY, but without it we could not think of a better way to show the match alert
    func checkForMatches(swipe: Swipe, completion: @escaping(Bool)-> Void) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("swipes").observeSingleEvent(of: .value, with: { snapshot in
            guard let rawData = snapshot.value else {
                return
            }
            
            guard let dictionary = rawData as? Dictionary<String, Any> else {
                return
            }
            let parsedDictionary = Array(dictionary.values)
            
            do {
                let data = try JSONSerialization.data(withJSONObject: parsedDictionary, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let model = try decoder.decode([Swipe].self, from: data)
                
                let filteredModel = model.filter{ $0.user1UID == swipe.user2UID && $0.user2UID == swipe.user1UID && $0.swipeDirection == .right}
                
                if(filteredModel.isEmpty){
                    completion(false)
                } else {
                    completion(true)
                }
            } catch {
                print(error)
                completion(false)
            }
        }) { error in
            print(error)
            completion(false)
        }
    }
}
