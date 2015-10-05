//
//  InstagramClient.swift
//  columbus
//
//  Created by Golak Sarangi on 10/5/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import Foundation

let consumerkey = "8f8f7c19b14c4a548330197a139d8ce8"
let consumerSecret = "cbf0c4ebf65940519ad3f615e9521523"
let baseUrl = "https://api.instagram.com"

class InstagramClient : BDBOAuth1RequestOperationManager{
    
    
    var loginCompletion :((user: User?, error: NSError?) ->())?
    
    class var sharedInstance: InstagramClient {
        struct Static {
            static let instance = InstagramClient(baseURL: NSURL(string: baseUrl), consumerKey: consumerkey, consumerSecret: consumerSecret)
        }
        return Static.instance
    }
    
    
    func loginWithCompletion (completion: (user: User?, error: NSError?) ->()){
        loginCompletion = completion
        
        InstagramClient.sharedInstance.requestSerializer.removeAccessToken()
        print("make call to authorize");
        InstagramClient.sharedInstance.fetchRequestTokenWithPath("/oauth/authorize", method: "GET", callbackURL: NSURL(string: "columbus://oauth"), scope: nil,
            success: {
                (requestToken: BDBOAuth1Credential!) -> Void in
                print("got the requestToken")
                
                let authUrl = NSURL(string: "\(baseUrl)/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authUrl!)
            }) { (error: NSError!) -> Void in
                print("Failed")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL (url: NSURL) {
        InstagramClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {
                (accessToken: BDBOAuth1Credential!) -> Void in
                print("got the access token")
                InstagramClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                InstagramClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    print("It verified")
                    print("user \(response)")
                    let loggedInUser = User(dictionary: response as! NSDictionary)
                    User.currentUser = loggedInUser
                    self.loginCompletion?(user: loggedInUser, error: nil)
                    }, failure: {
                        (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        print("Could not get the user")
                        self.loginCompletion?(user: nil, error: error)
                })
                
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    /*func fetchTweets(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let allTweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: allTweets, error: nil)
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error)
                print("Could not get the tweets")
                completion(tweets: nil, error: error)
                
        })
    }
    
    func postNewTweet(params: NSDictionary?, completion: (response: AnyObject?, error: NSError?) ->()) {
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(response: response, error: nil)
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error)
                print("Could not save the tweets")
                completion(response: nil, error: error)
                
        })
    }
    
    
    func reTweet(params: NSDictionary?, completion: (response: AnyObject?, error: NSError?) ->()) {
        let tweetId = params!["id"] as! String
        let url = "/1.1/statuses/retweet/\(tweetId).json"
        TwitterClient.sharedInstance.POST(url, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("successfully retweeted")
            completion(response: response, error: nil)
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(response: nil, error: error)
                
        })
    }
    
    func favorite(params: NSDictionary?, completion: (response: AnyObject?, error: NSError?) ->()){
        TwitterClient.sharedInstance.POST("/1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(response: response, error: nil)
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(response: nil, error: error)
                
        })
    }*/
    
}
