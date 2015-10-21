//
//  AddLocationTableViewController.swift
//  columbus
//
//  Created by Victor Zhang on 10/11/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var locations: [Location]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        locationSearchBar.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.locations != nil {
            return self.locations!.count
        }
        else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        var l = self.locations![indexPath.row]
        cell.textLabel?.text = l.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        var loc = self.locations![row]
        print("\(loc.name)")
        print("\(loc.lat)")
        print("\(loc.lng)")

        GoogleClient.sharedInstance.lookUpPlaceID(loc.placeID!) { (success, locations) -> Void in
            if success {
                if let loc = locations {
                print("\(loc.name)")
                print("\(loc.lat)")
                print("\(loc.lng)")
                }
            }
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell != nil {
            
        }
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar)
    {
        print("search clicked: \(searchBar.text!)")
        GoogleClient.sharedInstance.placeAutocomplete(searchBar.text!, callback: {(success, locationList) -> Void in
            if (success) {
                self.locations = locationList
                self.tableView.reloadData()
            } else {
                print("got no locations to list")
            }
        })

    }
    
    func searchBar( searchBar: UISearchBar, textDidChange searchText: String) {
        print("searching...\(searchText)")
    }

    @IBAction func onBackPressed(sender: AnyObject) {
                self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
