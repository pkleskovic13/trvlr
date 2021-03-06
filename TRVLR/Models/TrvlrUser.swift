//
//  User.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/8/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation

struct User: Codable {
    var uid: String
    var email: String
    var username: String
    var profileImageUrl: String
    var about: String
    var age: String
    var traveler: Bool
    var homeLocation: String
    var currentTravelDestination: String
    var gender: Gender
    var lookingFor: LookingFor
}

enum Gender: String, Codable {
    case male = "male"
    case female = "female"
    case none = ""
}

enum LookingFor: String, Codable {
    case male = "male"
    case female = "female"
    case both = "both"
    case none = ""
}

