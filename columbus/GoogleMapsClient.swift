//
//  GoogleMapsClient.swift
//  columbus
//
//  Created by Golak Sarangi on 10/12/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import Foundation

class GoogleClient {
    class var sharedInstance: GoogleClient {
        struct Static {
            static let instance = GoogleClient()
        }
        return Static.instance
    }
    
    static let APIKEY: String = "AIzaSyD7KGVXHJQQGh16qiGSte4dAO0n409QsjQ"
    
}