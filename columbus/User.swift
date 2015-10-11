//
//  User.swift
//  columbus
//
//  Created by Golak Sarangi on 10/5/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import Foundation

var _currentUser : User?
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var full_name: String?
    var username: String?
    var profile_picture: String?
    var bio: String?
    var website: String?
    var dictionary : NSDictionary?
    var location: Location?

    
    init (dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        full_name = dictionary["name"] as? String
        username = dictionary["username"] as? String
        bio = dictionary["bio"] as? String
        website = dictionary["website"] as? String
        profile_picture = dictionary["profile_picture"] as? String
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
    
    func logout() {
        //Clear current user
        User.currentUser = nil
        //InstagramClient.sharedInstance.requestSerializer.removeAccessToken() //removes permissions
        
        //NSUserNotification Center is like post office
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil) //tells anyone who is interested this happened
        
    }
    
}