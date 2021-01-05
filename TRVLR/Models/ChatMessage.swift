//
//  ChatMessage.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/9/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation
import MessengerKit

struct ChatMessage: Codable {
    var type: String
    var value: String
    var userUID: String
    var date: String
}

