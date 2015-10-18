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

class MapsViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, GMSMapViewDelegate {
    var location: Location?
    let locationManager = CLLocationManager()
    var mediaItems: NSArray?
    var gmapView: GMSMapView?
    var currentTappedIndex : Int?
    var gotLocation = false
    
    @IBAction func favButtonClicked(sender: UIButton) {
        sender.setImage(UIImage(named: "red_fav"), forState: .Normal)
        
        var userFav = NSUserDefaults.standardUserDefaults().objectForKey("userfav") as? NSMutableArray
        
        userFav = userFav ?? ( NSMutableArray())
        let someMediaUrls = getMediaUrls()
        
        let newFav = NSMutableDictionary()
        newFav.setValue(getSerializeCurrentLocation(), forKey: "location")
        newFav.setValue(someMediaUrls, forKey: "mediaUrls")
        userFav!.addObject(newFav);
        NSUserDefaults.standardUserDefaults().setObject(userFav, forKey: "userFav")
        NSUserDefaults.standardUserDefaults().synchronize()

        
        
    }
    @IBAction func locationButtonClicked(sender: UIButton) {
        gotLocation = false
        self.location = User.currentUser!.location
        getCurrentLocation()
    }
    @IBOutlet weak var mapView: UIView!
    

    @IBOutlet weak var currentLocationButton: UIButton!

    @IBOutlet weak var favoriteButton: UIButton!
    
    func getSerializeCurrentLocation() -> [String:String] {
        var serializedLocation = [String:String]()
        serializedLocation["lat"] = location!.lat
        serializedLocation["lng"] = location!.lng
        serializedLocation["name"] = location!.name
        return serializedLocation
    }
    
    func getMediaUrls() -> [String]{
        var mediaUrls = [String]();
        if (mediaItems == nil) {
            return mediaUrls
        }
        
        for (var locindex = 0 ; locindex < mediaItems!.count; locindex++) {
            let mediaList = mediaItems![0]["mediaItem"] as! NSArray
            for (var medIndex = 0; medIndex < mediaList.count; medIndex++) {
                let media = mediaList[0] as! NSDictionary
                mediaUrls.append(media.valueForKeyPath("images.low_resolution.url") as! String)
            }
        }
        
        return mediaUrls
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        getCurrentLocation();
        gotLocation = false
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
            print("location is available")
            self.addMapToMapView()
            
            getMediaInSelectedLocation()
        }
    }
    
    func getMediaInSelectedLocation () {
        InstagramClient.sharedInstance.getNearByMediaItems(location!, callback:{  (success, mediaItems) -> Void in
            if success {
                self.mediaItems = mediaItems
                self.showMediaInMap()
            } else {
                print("Error in fetching nearby media items to show on the map")
            }
        });
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation = manager.location
        if (gotLocation) {
            return
        }
        gotLocation = true
        
        print("latitude \((currLocation?.coordinate.latitude)!)")
        print("longitude \((currLocation?.coordinate.longitude)!)")
        
        self.location = Location(lat: "\((currLocation?.coordinate.latitude)!)",lng: "\((currLocation?.coordinate.longitude)!)")
        //this line is for simulation. remove it
        //self.location = Location(lat: "40.7577", lng: "-73.9857")
        User.currentUser!.location = location
        getMediaInSelectedLocation()
        self.addMapToMapView()
        
        locationManager.stopUpdatingLocation()
    }
    
    func showMediaInMap() {
        for var index = 0 ; index < self.mediaItems!.count; index++ {
            let obj = self.mediaItems![index] as! NSDictionary
            
            createImageForMarker(obj, currIndex: index);
            
        }
    }
    
    func createMapMarker(lat: String, lng: String, image: UIImage, title : String, snippet: String, currIndex: Int) {
        let position = CLLocationCoordinate2DMake(Double(lat)!, Double(lng)!)
        let marker = GMSMarker(position: position)
        marker.title = title
        marker.icon = image
        marker.snippet = snippet
        self.gmapView?.delegate = self
        marker.map = self.gmapView
        marker.userData = currIndex
        //let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        //recognizer.delegate = self

    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        self.currentTappedIndex = marker.userData as? Int
        performSegueWithIdentifier("maptodetailed", sender: self)
    }
    
    
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("\(coordinate.latitude)")
        self.location = Location(lat: "\(coordinate.latitude)",lng: "\(coordinate.longitude)")
        //this line is for simulation. remove it
        //self.location = Location(lat: "40.7577", lng: "-73.9857")
        getMediaInSelectedLocation()
        self.addMapToMapView()
    }
    
    

    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "maptodetailed" {
            let vc = segue.destinationViewController as! MediaDetailedViewController
            print(self.currentTappedIndex)
            
            vc.mediaAtLoc = self.mediaItems![currentTappedIndex!] as? NSDictionary
            print(vc.mediaAtLoc!["mediaItem"])
        }
    }
    
    /*func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }*/
    
    
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    
    func createImageForMarker(obj : NSDictionary, currIndex: Int) {
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
                let tags = (media["tags"] as! Array).joinWithSeparator("-")
                
                var title = media.valueForKeyPath("caption.text") as? String
                if title == nil {
                    title = media.valueForKeyPath("user.username") as? String
                }
                self.createMapMarker(location.lat!, lng: location.lng!, image: locationImage, title: title!, snippet: tags, currIndex: currIndex)
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error in fetching location")
    }
    
    func addMapToMapView() {
        let camera = GMSCameraPosition.cameraWithLatitude(Double(self.location!.lat!)!,
            longitude: Double(self.location!.lng!)!, zoom: 24)
        if (self.gmapView == nil) {
            self.gmapView = GMSMapView.mapWithFrame(CGRectMake(0, 0, self.mapView.bounds.width, self.mapView.bounds.height), camera: camera)
            self.gmapView!.myLocationEnabled = true
            self.mapView.addSubview(self.gmapView!)
        } else {
            self.gmapView!.animateToCameraPosition(camera)
        }
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
