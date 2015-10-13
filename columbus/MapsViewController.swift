//
//  MapsViewController.swift
//  columbus
//
//  Created by Golak Sarangi on 10/13/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapsViewController: UIViewController, CLLocationManagerDelegate {
    var location: Location?
    let locationManager = CLLocationManager()
    var mediaItems: NSArray?
    
    @IBOutlet weak var mapView: UIView!
    

    @IBOutlet weak var currentLocationButton: UIButton!

    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        getCurrentLocation();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentLocation() {
        if (location == nil) {
            if #available(iOS 9.0, *) {
                print("ios9")
                self.locationManager.requestLocation()
            } else {
                self.locationManager.startUpdatingLocation()
            }
        } else {
            
            getMediaInSelectedLocation()
        }
    }
    
    func getMediaInSelectedLocation () {
        InstagramClient.sharedInstance.getNearByMediaItems(location!, callback:{  (success, mediaItems) -> Void in
            self.mediaItems = mediaItems
        });
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation = manager.location
        
        self.location = Location(lat: "\(currLocation?.coordinate.latitude)",lng: "\(currLocation?.coordinate.longitude)")
        //this line is for simulation. remove it
        self.location = Location(lat: "40.7577", lng: "73.9857")
        User.currentUser!.location = location
        getMediaInSelectedLocation()
        self.addMapToMapView()
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error in fetching location")
    }
    
    func addMapToMapView() {
        let camera = GMSCameraPosition.cameraWithLatitude(Double(self.location!.lat!)!,
            longitude: Double(self.location!.lng!)!, zoom: 6)
        let gmapView = GMSMapView.mapWithFrame(CGRectMake(0, 0, self.mapView.bounds.width, self.mapView.bounds.height), camera: camera)
        gmapView.myLocationEnabled = true
        self.mapView.addSubview(gmapView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
