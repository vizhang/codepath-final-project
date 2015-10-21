//
//  GoogleMapsClient.swift
//  columbus
//
//  Created by Golak Sarangi on 10/12/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import Foundation

class GoogleClient {

    var placesClient: GMSPlacesClient?

    class var sharedInstance: GoogleClient {
        struct Static {
            static let instance = GoogleClient()
        }

        return Static.instance
    }
    
    static let APIKEY: String = "AIzaSyD7KGVXHJQQGh16qiGSte4dAO0n409QsjQ"
    //static let APIKEY: String = "AIzaSyBqabmZ4JEmWrv2E6QQNRKzxdquvOwoDnY"

    
    func placeAutocomplete(queryString: String, callback: (success: Bool, locations: [Location]?)-> Void) {
        self.placesClient = GMSPlacesClient()
        print("place Autocomplete started")
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.City
        placesClient?.autocompleteQuery(queryString, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            
            if let error = error {
                print("Autocomplete error \(error)")
                callback(success: false, locations: nil)
            }
            else {
                var locations = [Location]()
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction {
                        let a = result.attributedFullText as NSAttributedString
                        let loc = Location(lat: "", lng: "", name: a.string, placeID: result.placeID)
                        locations.append(loc)
                    }
                }

                callback(success: true, locations: locations)
            }
            
        })
    }
    
    func lookUpPlaceID (placeID: String, callback: (success: Bool, locations: Location?)-> Void)  {
        self.placesClient = GMSPlacesClient()
        placesClient?.lookUpPlaceID(placeID, callback: { (retGMSPlace: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("lookup error")
                callback(success: false, locations: nil)
            } else {
                if let retGMSPlace = retGMSPlace as GMSPlace? {
                    var lng = String(retGMSPlace.coordinate.longitude)
                    var lat = String(retGMSPlace.coordinate.latitude)

                    callback(success: true, locations: Location(lat: lat, lng:lng, name:retGMSPlace.name, placeID: retGMSPlace.placeID))
                }
            }
        })
    }
    
}
