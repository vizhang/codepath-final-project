//
//  ViewController.swift
//  columbus
//
//  Created by Victor Zhang on 9/28/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit




class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginAction(sender: UIButton) {
        InstagramClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                print("loggedin")
            } else {
                print("Error")
            }
        }
        

/*        let oauthswift = OAuth2Swift(
            consumerKey:    "8f8f7c19b14c4a548330197a139d8ce8",
            consumerSecret: "cbf0c4ebf65940519ad3f615e9521523",
            authorizeUrl:   "https://api.instagram.com/oauth/authorize",
            responseType:   "token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/instagram")!, scope: "likes+comments", state:"INSTAGRAM", success: {
            credential, response, parameters in
            println(credential.oauth_token)
            }, failure: {
                
        })*/
    }
}

