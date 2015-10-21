//
//  InstagramClient.swift
//  columbus
//
//  Created by Golak Sarangi on 10/5/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import Foundation
import UIKit




let consumerkey = "38e3a648a4054d43a160df95a7762c31"
let consumerSecret = "cf7e64a288df4705aad50f02c538ef01"
let baseUrl = "https://api.instagram.com"
let distance = 1000

class InstagramClient : BDBOAuth1RequestOperationManager {
    
    var loginCompletion :((user: User?, error: NSError?) ->())?
    var accessToken : String?
    
    class var sharedInstance: InstagramClient {
        struct Static {
            static let instance = InstagramClient()
        }
        return Static.instance
    }
    
    /*
    func setAccessToken (accessToken: NSString) {
        
    }
    
    init() {
        
    }
    */
    
    func loginWithCompletion (completion: (user: User?, error: NSError?) ->()){
        //loginCompletion = completion

        //Clean things up before we get going
        //Fetch request token and redirect to authorization page
        //InstagramClient.sharedInstance.requestSerializer.removeAccessToken()
        
        UIApplication.sharedApplication().openURL(NSURL(string: "\(baseUrl)/oauth/authorize?client_id=\(consumerkey)&redirect_uri=columbus://oauth&response_type=token")!)
        
        /*InstagramClient.sharedInstance.fetchRequestTokenWithPath("/oauth/authorize", method: "GET", callbackURL: NSURL(string: "columbus://oauth"), scope: nil,
            success: {
                (requestToken: BDBOAuth1Credential!) -> Void in
                print("got the requestToken")
                
                let authUrl = NSURL(string: "\(baseUrl)/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authUrl!)
            }) { (error: NSError!) -> Void in
                print("Failed")
                self.loginCompletion?(user: nil, error: error)
        }*/
    }
    
    
    func getNearByMediaItems(location: Location, callback: (Bool, NSArray)->Void) {
        var allMediaItem = NSMutableArray()
        var totalCount = 0
        var errors = false
        var iterationDone = false
        
        func afterFetch() {
            if totalCount == 0  && iterationDone{
                if(errors) {
                    callback(false, [])
                } else {
                    callback(true, allMediaItem)
                }
            }
        }
        
        getNearByPlaces(location, callback: {(success, locationList) -> Void in
            if (success) {
                for var index = 0; index < locationList.count ; ++index {
                    totalCount++
                    
                    
                    let eachLocation = locationList[index] as! NSDictionary
                    let locationDetails = NSMutableDictionary()
                    locationDetails.setValue(Location(lat: String(eachLocation["latitude"]!), lng: String(eachLocation["longitude"]!) , name: String(eachLocation["name"])), forKey: "location")
                    let locationId = eachLocation["id"] as! String
                    self.getRecentMedia(locationId, callback: {(success, mediaList) -> Void in
                        totalCount--
                        if (success) {
                            locationDetails.setValue(mediaList, forKey: "mediaItem")
                            allMediaItem.addObject(locationDetails)
                        } else {
                            print("error while fetching")
                            errors = true
                        }
                        afterFetch()
                    })
                }
                iterationDone = true
            } else {
                errors = true
                iterationDone = true
                afterFetch()
            }
        })
        
        
    }
    
    
    
    func getNearByPlaces (location: Location, callback: (Bool, NSArray)-> Void) {
        let url = "/v1/locations/search"

        var params: [String:String] = [:]
        params["lat"] = location.lat
        params["lng"] = location.lng
        params["distance"] = "\(distance)"
        sendRequest(url, method: "GET", params: params, callback: {(success, json) -> Void in
            if(success) {
                callback(success, json as! NSArray)

            } else {
                callback(success, []);
            }
        })

    }
    
    
    func getRecentMedia(locationId: String, callback: (Bool, NSArray)-> Void) {
        let url = "/v1/locations/\(locationId)/media/recent"
        sendRequest(url, method: "GET", params: [:], callback: {(success, json) -> Void in
            if(success) {
                callback(success, json as! NSArray)
            } else {
                callback(success, [])
            }
        })
    }
    
    func getCurrentUser(callback: (Bool, NSDictionary)-> Void) {
        getUser("self", callback: callback)
    }
    
    func getUser(userid: String, callback: (Bool, NSDictionary)-> Void){
        let url = "/v1/users/\(userid)"
        sendRequest(url, method: "GET", params: [:], callback: {(success, json) -> Void in
            if(success) {
                callback(success, json as! NSDictionary)
            } else {
                print("getting user has failed: \(json)")
                callback(success, [:])
            }
        })
    }
    
    
    func sendRequest(url: String, method: String,var  params: [String: String], callback: (Bool, AnyObject) -> Void) {
        let manager = AFHTTPRequestOperationManager()
        let fullUrl = baseUrl + url

        params["access_token"] = self.accessToken
        switch(method) {
        case "GET":
            manager.GET(fullUrl, parameters: params, success: { (operation, responseObject) -> Void in
                if let results = responseObject["data"]  {
                    callback(true, results!)
                } else {
                    callback(false, responseObject)
                }
            }, failure: { (operation, requestError) -> Void in
                    print(requestError)
                    callback(false, requestError)
            })
        default:
            print("The method is not supported")
        }
    }
    
    
    

    
    
}
