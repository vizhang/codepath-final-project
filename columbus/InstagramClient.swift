//
//  InstagramClient.swift
//  columbus
//
//  Created by Golak Sarangi on 10/5/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import Foundation
import UIKit




let consumerkey = "8f8f7c19b14c4a548330197a139d8ce8"
let consumerSecret = "cbf0c4ebf65940519ad3f615e9521523"
let baseUrl = "https://api.instagram.com"

class InstagramClient : BDBOAuth1RequestOperationManager {
    
    var loginCompletion :((user: User?, error: NSError?) ->())?
    var accessToken : String?;
    
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
        loginCompletion = completion

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
    
    
    func getNearByPlaces (lat : String, lng: String) {
        let url = "/v1/locations/search";

        var params: [String:String] = [:];
        params["lat"] = lat;
        params["lng"] = lng;
        sendRequest(url, method: "GET", params: params, callback: {(success, json) -> Void in
            if(success) {
                print("successfully fetched");
            } else {
                print("Error while fetching");
            }
        });

    }
    
    
    func getRecentMedia() {
        let url = "/locations/location-id/media/recent"
    }
    
    
    func sendRequest(url: String, method: String,var  params: [String: String], callback: (Bool, AnyObject) -> Void) {
        let manager = AFHTTPRequestOperationManager()
        let fullUrl = baseUrl + url;
        print("full URL: \(fullUrl)")
        params["access_token"] = self.accessToken
        switch(method) {
        case "GET":
            manager.GET(fullUrl, parameters: params, success: { (operation, responseObject) -> Void in
                if let results = responseObject["data"]  {
                    callback(true, results!)
                } else {
                    callback(false, responseObject);
                }
            }, failure: { (operation, requestError) -> Void in
                    callback(false, requestError);
            })
        default:
            print("The method is not supported");
        }
    }
    
    

    
    
}
