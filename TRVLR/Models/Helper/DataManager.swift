//
//  DataManager.swift
//  TRVLR
//
//  Created by Klara Lucianovic (RIT Student) on 12/9/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class DataManager {
    static let shared = DataManager()
    var userID: String? {
        return Auth.auth().currentUser?.uid
    }
    private var matches: [Match] = []
    var ref: DatabaseReference!
    
    
    init() {
        ref = Database.database().reference()
        fetchAllMatches(completion: { (foundMatches) in
            self.matches = foundMatches
        })
    }
    
    func fetchAllMatches(completion: @escaping ([Match])-> Void) {
        
        let plsWork: [Match] = []
        
        ref.child("matches").observe(.value, with: { (snapshot) in
            
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
                let model = try decoder.decode([Match].self, from: data)
                
                // filters all matches to find those that include the active user
                guard let currentUID = self.userID else { return }
                
                let filteredModel = model.filter { $0.user1UID == currentUID || $0.user2UID == currentUID }
                
                completion(filteredModel)
            } catch {
                print(error)
                completion(plsWork)
            }
        }) { error in
            print(error)
            completion(plsWork)
        }
        
    }
    
    func getUserByUID(uid: String, completion: @escaping (AsyncUserResponse) -> Void) {
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let rawData = snapshot.value else {
                return
            }
            /*
             guard let dictionary = rawData as? Dictionary<String, Any> else {
             return
             }
             let parsedDictionary = Array(dictionary.values)
             */
            
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
    
    func fetchAllSwipes(completion: @escaping ([Swipe]) -> Void) {
        let plsWork: [Swipe] = []
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
                
                completion(model)
            } catch {
                print(error)
                completion(plsWork)
            }
        }) { error in
            print(error)
            completion(plsWork)
        }
    }
    
    func fetchAllSwipes(forUser uid: String, completion: @escaping ([Swipe]) -> Void) {
        let plsWork: [Swipe] = [
            Swipe(user1UID: uid, user2UID: uid, swipeDirection: .left)
        ]
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
                var model = try decoder.decode([Swipe].self, from: data)
                
                model = model.filter({ (swipe) -> Bool in
                    swipe.user1UID == uid
                })
                
                completion(model)
            } catch {
                print(error)
                completion(plsWork)
            }
        }) { error in
            print(error)
            completion(plsWork)
        }
    }
    
    func pushSwipeToDatabase(swipe: Swipe) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let swipeDictionary: Dictionary<String, Any> = [
            "user1UID": swipe.user1UID,
            "user2UID": swipe.user2UID,
            "swipeDirection": swipe.swipeDirection.rawValue
        ]
        ref.child("swipes").childByAutoId().setValue(swipeDictionary)
        
        if(swipe.swipeDirection == .right) {
            checkForMatches(swipe: swipe) { (match) in
                print(match)
            }
        }
    }
    
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
                    let calculatedUniqueChatID = "\(filteredModel[0].user1UID)\(filteredModel[0].user2UID)"
                    let match: Dictionary<String, Any> = [
                        "user1UID": filteredModel[0].user1UID,
                        "user2UID": filteredModel[0].user2UID,
                        "chatUID": "\(calculatedUniqueChatID)"
                    ]
                    let initialChat: Dictionary<String, Any> = [
                        "date": "\(Date.timeIntervalSinceReferenceDate)",
                        "type": "text",
                        "userUID": filteredModel[0].user1UID,
                        "value": "Hello there! Let's be friends!"
                    ]
                    ref.child("matches").child(calculatedUniqueChatID).setValue(match)
                    ref.child("chats/\(calculatedUniqueChatID)").childByAutoId().setValue(initialChat)
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
    
    func getAllChats(completion: @escaping([[ChatMessage]])-> Void) {
        ref.child("chats").observeSingleEvent(of: .value, with: { snapshot in
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
                let model = try decoder.decode([[ChatMessage]].self, from: data)
                
                completion(model)
            } catch {
                print(error)
            }
        }) { error in
            print(error)
        }
    }
    
    func fetchAllUsers(completion: @escaping ([User])-> Void) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let plsWork: [User] = []           //MARK: REMOVE THIS, IT'S A WORKAROUND
        
        ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
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
                let model = try decoder.decode([User].self, from: data)
                completion(model)
            } catch {
                print(error)
                completion(plsWork)
            }
        }) { error in
            print(error)
            completion(plsWork)
        }
        
    }
}
