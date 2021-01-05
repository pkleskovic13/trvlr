//
//  AsyncResponse.swift
//  TRVLR
//
//  Created by Klara Lucianovic (RIT Student) on 12/8/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import Foundation

class AsyncUserResponse {
    var error: Error?
    var user: User?
    
    init(user: User) {
        self.error = nil
        self.user = user
    }
    
    init(error: Error) {
        self.error = error
        self.user = nil
    }
    
}
