//
//  KolodaViewControllerDataSourceDelegate.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/7/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation
import Koloda
import Firebase
import Kingfisher

extension KolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return users.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UserCardView()
        view.configure(for: users[index])
        
        return view
    }
    

}
