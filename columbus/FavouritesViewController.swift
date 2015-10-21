//
//  FavouritesViewController.swift
//  columbus
//
//  Created by Victor Zhang on 10/11/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noFavs1Label: UILabel!
    @IBOutlet weak var noFavs2Label: UILabel!
    
    var userFav : NSArray?
    
    var locations : [Location]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Some Text if you don't have any locations saved, otherwise hide it
        fetchUserFavFromStorage()
        let numberOfFavs = userFav?.count ?? 0
        if numberOfFavs > 0 {
            noFavs1Label.hidden = true
            noFavs2Label.hidden = true
            tableView.hidden = false

            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        } else {
            print("yee")
            noFavs1Label.hidden = false
            noFavs2Label.hidden = false
            tableView.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserFavFromStorage() {
        userFav = NSUserDefaults.standardUserDefaults().objectForKey("userFav") as? NSArray
        userFav = userFav ?? ( NSArray())
        print(userFav)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (userFav?.count == 0) {
            noFavs1Label.hidden = true
        }
        print("counting stars")
        return userFav?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("adding table cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationTableViewCell
        print("indede");
        let fav = userFav![indexPath.item] as! NSDictionary
        print("before loc")
        var location = fav["location"] as! [String:String]
        print("after loc")
        let locationName = location["name"] ?? ""
        let lat = location["lat"]
        let lng = location["lng"]
        let title = "\(locationName) (lat: \(lat!) , lng: \(lng!)"
        print(title);
        
        cell.nameLabel.text = title
        
        let mediaUrls = fav["mediaUrls"] as? [String]
        print("this shold be added")
        
        addMediaImages(mediaUrls, cell: cell)
        

        
        
        //cell.tweet = self.tweets![indexPath.row]
        return cell
    }
    
    func addMediaImages(mediaUrls: [String]?, cell: LocationTableViewCell) {
        if let mediaUrls = mediaUrls {
            for var i = 0; i < mediaUrls.count; i++ {
                let url = mediaUrls[i]
                let mediaImageView = UIImageView()
                mediaImageView.frame = CGRect(x: 200 * i, y: 0, width: 200, height: 200)
                cell.imageHolder.addSubview(mediaImageView)
                mediaImageView.setImageWithURL(NSURL(string: url))
            }
        }
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        print("add new location pressed")
        //Open modal for a new search popover
        performSegueWithIdentifier("segueToAddLocation", sender: nil)
        //
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
