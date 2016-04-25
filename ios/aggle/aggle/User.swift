//
//  User.swift
//  aggle
//
//  User vanilla object
//
//  Created by Max Li on 4/19/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import Foundation

class User {
    class var sharedInstance: User {
        struct Static {
            static var instance: User?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = User()
        }
        
        return Static.instance!
    }
    
    var uid: String!
    var name: String!
    var email: String!
    var zip: String!
    var pic: String!
    var itemText: String!
    var itemDescrip: String!
    var itemPic: String!
    var numberSold: Int = 0
}