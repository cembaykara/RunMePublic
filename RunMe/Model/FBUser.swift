//
//  FBUser.swift
//  RunMe
//
//  Created by Baris Cem Baykara on 11/27/17.
//  Copyright © 2017 Baris Cem Baykara. All rights reserved.
//

import Foundation

class FBUser {

    var userInfo = [String:AnyObject]()
    
    init(_ user: [String:AnyObject]) {
        userInfo["first_name"] = user["first_name"]
        userInfo["middle_name"] = user["middle_name"]
        userInfo["id"] = user["id"]
        userInfo["email"] = user["email"]
        let url = user["picture"]!["data"]! as AnyObject
        userInfo["url"] = url["url"]! as AnyObject
        userInfo["friends"] = user["friends"]!["data"]! as AnyObject
    }
    
    
}
