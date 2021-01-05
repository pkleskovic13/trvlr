//
//  Swipe.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/9/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation

struct Swipe: Codable {
    var user1UID: String
    var user2UID: String
    var swipeDirection: SwipeDirection
}

enum SwipeDirection: String, Codable {
    case left = "left"
    case right = "right"
}
