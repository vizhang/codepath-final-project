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
    
    var locations : [Location]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Some Text if you don't have any locations saved, otherwise hide it
        let numberOfLocation = locations?.count ?? 0
        if numberOfLocation > 0 {
            print("wah")
            noFavs1Label.hidden = true
            noFavs2Label.hidden = true
            tableView.hidden = false
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationTableViewCell
        //cell.tweet = self.tweets![indexPath.row]
        return cell
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        print("add new location pressed")
        //Open modal for a new search popover
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
