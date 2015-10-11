//
//  location.swift
//  columbus
//
//  Created by Golak Sarangi on 10/11/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import Foundation


class Location: NSObject {
    var lat: String?
    var lng: String?
    var name: String?
    
    init(lat : String, lng: String) {
        self.lat = lat
        self.lng = lng
    }
    init(lat: String, lng: String, name: String) {
        self.lat = lat
        self.lng = lng
        self.name = name
    }
}
