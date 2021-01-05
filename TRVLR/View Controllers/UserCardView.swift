//
//  UserCardView.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/8/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit
import Kingfisher

class UserCardView: UIView {
    let kCONTENT_XIB_NAME = "UserCardView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var travelerLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    
    func configure(for user: User) {
        self.nameLabel.text = "\(user.username), \(user.age)"
        self.descriptionTextView.text = "\(user.about)"
        self.profileImageView.kf.setImage(with: URL(string: user.profileImageUrl))
        self.locationLabel.text = "\(user.homeLocation)"
        if(!user.currentTravelDestination.isEmpty) {
            self.travelerLabel.text = "Next Travel to: \(user.currentTravelDestination)"
        } else {
            self.travelerLabel.text = "Local"
        }
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.profileImageView.contentMode = .scaleAspectFill
    }

}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
