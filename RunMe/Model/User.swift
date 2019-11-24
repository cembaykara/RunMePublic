//
//  User.swift
//  RunMe
//
//  Created by Baris Cem Baykara on 11/22/17.
//  Copyright © 2017 Baris Cem Baykara. All rights reserved.
//

import Foundation

class User {
    
    var userinfo = [String : String?]()
    
    init (_ userName: String?, _ userEmail: String?, _ uid: String?){
        userinfo["username"] = userName
        userinfo["email"] = userEmail
        userinfo["uid"] = uid
    }
    init?(with username: String?) {
        userinfo["username"] = username
    }
    
    
}
