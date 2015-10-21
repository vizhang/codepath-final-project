//
//  MediaDetailedViewController.swift
//  columbus
//
//  Created by Golak Sarangi on 10/13/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import UIKit

class MediaDetailedViewController: UIViewController {
    var mediaAtLoc: NSDictionary?
    var startIndex: Int = -1


    @IBOutlet weak var otherDetailsLabel: UILabel!

    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var mediaImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTheMedia()
        // Do any additional setup after loading the view.
    }
    
    
    func loadTheMedia() {
        let mediaItems = mediaAtLoc!["mediaItem"] as! NSArray
        print("media Items count \(mediaItems.count)")
        let location = mediaAtLoc!["location"]
        if (startIndex >= mediaItems.count) {
            startIndex = 0
        }
        if (startIndex < 0) {
            startIndex = mediaItems.count - 1
        }
        let currentMedia = mediaItems[startIndex] as! NSDictionary
        
        locationLabel.text = location!.name!
        mediaImageView.setImageWithURL(NSURL(string: currentMedia.valueForKeyPath("images.standard_resolution.url") as! String))
        tagsLabel.text = (currentMedia["tags"] as! Array).joinWithSeparator(", ")
        
        var title = currentMedia.valueForKeyPath("caption.text") as? String
        if title == nil {
            title = currentMedia.valueForKeyPath("user.username") as? String
        }
        otherDetailsLabel.text = title
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSwipeOnMedia(sender: UISwipeGestureRecognizer) {
        print("gesture");
        
        if sender.direction == UISwipeGestureRecognizerDirection.Right {
            startIndex++;
        } else {
            startIndex--;
        }
        loadTheMedia()
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
