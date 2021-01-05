//
//  ChatUser.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/7/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation
import UIKit
import MessengerKit


class ChatUser: MSGUser {
    var displayName: String
    var avatar: UIImage? = nil
    var avatarUrl: String?
    var isSender: Bool
    
    init(displayName: String, avatarUrl: String?, isSender: Bool) {
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        self.isSender = isSender
    }
}
