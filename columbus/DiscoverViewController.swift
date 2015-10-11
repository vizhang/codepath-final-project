//
//  DiscoverViewController.swift
//  columbus
//
//  Created by Victor Zhang on 10/11/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import UIKit
import CoreLocation

class DiscoverViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    var location: Location?
    let locationManager = CLLocationManager()
    

    @IBOutlet weak var mediaCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Discover View Did load")
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        getCurrentLocation();
        
        self.mediaCollectionView.delegate = self
        self.mediaCollectionView.dataSource = self


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentLocation() {
        if (location == nil) {
            if #available(iOS 9.0, *) {
                self.locationManager.requestLocation()
            } else {
                self.locationManager.startUpdatingLocation()
            }
        } else {
            getMediaInSelectedLocation()
        }
    }
    
    func getMediaInSelectedLocation () {
        InstagramClient.sharedInstance.getNearByMediaItems(location!, callback:{  (success, MediaItems) -> Void in
            print("recevied it all")
            print(success)
            print(MediaItems)
        });
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation = manager.location
        self.location = Location(lat: "(currLocation?.coordinate.latitude)",lng: "(currLocation?.coordinate.longitude)")
        //this line is for simulation. remove it
        self.location = Location(lat: "40.7577", lng: "-73.9857")
        User.currentUser!.location = location
        getMediaInSelectedLocation()
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error in fetching location")
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = self.mediaCollectionView.dequeueReusableCellWithReuseIdentifier("mediaUICollectionViewCell", forIndexPath: indexPath) as! MediaItemCollectionViewCell
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
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


class MediaItemCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var mediaImageView: UIImageView!
    var locationName: String?
    var latlng: Location?
    
}
