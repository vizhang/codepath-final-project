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
    var gmapView: GMSMapView?
    
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
        print("get media in selected location in maps controller")
        InstagramClient.sharedInstance.getNearByMediaItems(location!, callback:{  (success, mediaItems) -> Void in
            self.mediaItems = mediaItems
            self.showMediaInMap()
        });
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation = manager.location
        
        self.location = Location(lat: "\(currLocation?.coordinate.latitude)",lng: "\(currLocation?.coordinate.longitude)")
        //this line is for simulation. remove it
        self.location = Location(lat: "40.7577", lng: "-73.9857")
        User.currentUser!.location = location
        getMediaInSelectedLocation()
        self.addMapToMapView()
        
        locationManager.stopUpdatingLocation()
    }
    
    func showMediaInMap() {
        for var index = 0 ; index < self.mediaItems!.count; index++ {
            let obj = self.mediaItems![index] as! NSDictionary
            
            createImageForMarker(obj);
            
        }
    }
    
    func createMapMarker(lat: String, lng: String, image: UIImage) {
        let position = CLLocationCoordinate2DMake(Double(lat)!, Double(lng)!)
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.icon = image
        marker.map = self.gmapView
    }
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    
    func createImageForMarker(obj : NSDictionary) {
        print(obj)
        let mediaList = obj["mediaItem"] as! NSArray
        if (mediaList.count == 0) {
            return;
        }
        let media = mediaList[0] as! NSDictionary
        
        if let url = NSURL(string: media.valueForKeyPath("images.low_resolution.url") as! String) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                let locationImage = self.imageResize(UIImage(data: data!)!, sizeChange: CGSizeMake(60, 60))
                
                
                
                let location = obj["location"] as! Location
                self.createMapMarker(location.lat!, lng: location.lng!, image: locationImage)
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error in fetching location")
    }
    
    func addMapToMapView() {
        let camera = GMSCameraPosition.cameraWithLatitude(Double(self.location!.lat!)!,
            longitude: Double(self.location!.lng!)!, zoom: 21)
        self.gmapView = GMSMapView.mapWithFrame(CGRectMake(0, 0, self.mapView.bounds.width, self.mapView.bounds.height), camera: camera)
        self.gmapView!.myLocationEnabled = true
        self.mapView.addSubview(self.gmapView!)
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
