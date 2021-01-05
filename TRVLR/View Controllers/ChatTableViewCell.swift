//
//  ChatTableViewCell.swift
//  TRVLR
//
//  Created by Klara Lucianovic (RIT Student) on 12/9/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit
import Kingfisher

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var user1: User?
    var user2: User?
    var chat: [ChatMessage]?
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for user: User, and match: Match) {
        imageUser.layer.cornerRadius = 30
        self.imageUser.kf.setImage(with: URL(string: user.profileImageUrl))
        self.usernameLabel.text = "\(user.username), \(user.homeLocation)"
        self.messageLabel.text = chat?.last?.value
    }
    
}
