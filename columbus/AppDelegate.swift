//
//  AppDelegate.swift
//  columbus
//
//  Created by Victor Zhang on 9/28/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        //Should check if path is columbus://oauth but for now assume it is the case
        
        print("came back from Instagram mobile web")
        let urlString = String(url)
        let urlArray = urlString.characters.split{$0 == "="}.map(String.init)
        //print("\(urlArray[1])")
        InstagramClient.sharedInstance.accessToken = urlArray[1]

        print("trying to get locations")
        //InstagramClient.sharedInstance.getNearByPlaces("43.6426", lng: "79.3871")
        
        InstagramClient.sharedInstance.getCurrentUser { (success, user) -> Void in
            print(user);
        }
/*        InstagramClient.sharedInstance.getNearByMediaItems("43.6426", lng: "79.3871") { (success, json) -> Void in
            if success {
                print("success")
                print(json)
            } else {
                print("failed")
            }
            
        }*/
        
        return true
    }


}

