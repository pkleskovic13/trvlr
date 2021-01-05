//
//  KolodaViewController.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/7/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit
import Koloda
import Firebase

// Koloda was implemented with the help of following resources:
// https://github.com/Yalantis/Koloda
// https://www.iosapptemplates.com/blog/ios-development/tinder-card-swipe-swift-koloda

class KolodaViewController: UIViewController {
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var ref: DatabaseReference!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //DataManager.shared.pushSwipeToDatabase(swipe: Swipe(user1UID: "20Ajy9MJvxfUGyRh2a2PoqbHgjk1", user2UID: "20Ajy9MJvxfUGyRh2a2PoqbHgjk1", swipeDirection: .left))
        
        DataManager.shared.fetchAllUsers { (users) in
            guard let currentUserID = DataManager.shared.userID else { return }
            
            DataManager.shared.fetchAllSwipes(forUser: currentUserID) { (allUserSwipes) in
                let filteredUsers = self.filterUserCards(unfilteredUsers: users, allSwipes: allUserSwipes)
                self.users = filteredUsers
                self.kolodaView.resetCurrentCardIndex()
            }
        }
    }
    
    @IBAction func didTapDislike(_ sender: UIButton) {
        kolodaView.swipe(.left)
    }
    @IBAction func didTapLike(_ sender: UIButton) {
        kolodaView.swipe(.right)
    }
    
}
