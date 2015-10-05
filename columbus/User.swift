//
//  User.swift
//  columbus
//
//  Created by Golak Sarangi on 10/5/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import Foundation

var _currentUser : User?


class User {
    var name: String?
    var dictionary : NSDictionary?
    
    init (dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
    }
    

    class var currentUser: User? {
        get {
        if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey("currentUserKey") as? NSData
        
        if data != nil {
        let dictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
        }
        }
        return _currentUser
        }
        set(user){
            _currentUser = user
            
            if (_currentUser != nil) {
                let data = try? NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentUserKey")
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "currentUserKey")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    
}