//
//  UserDetails.swift
//  springshow
//
//  Created by mitchell hudson on 2/15/15.
//  Copyright (c) 2015 mitchell hudson. All rights reserved.
//

import Foundation

class UserDetails {
    var user: PFUser!
    var username: String {
        return user.username
    }
    
    func getUser() {
        user = PFUser.currentUser()
        
    }
}