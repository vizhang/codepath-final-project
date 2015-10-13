//
//  MainViewController.swift
//  columbus
//
//  Created by Golak Sarangi on 10/13/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var contentViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var contentViewRightMargin: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomMargin: NSLayoutConstraint!
    var currentViewController = "DiscoverViewController"
    

    override func viewDidLoad() {
        print("Main view loaded")
        super.viewDidLoad()
        showCurrentViewController()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            print("content View Controller")
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            contentViewController.willMoveToParentViewController(self)
            let newContentView = contentViewController.view
            newContentView.frame.size.width = view.frame.size.width
            contentView.addSubview(newContentView)
            contentViewController.didMoveToParentViewController(self)
            
            UIView.animateWithDuration(0.3) { () -> Void in
                self.contentViewLeftMargin.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func onPanGesture(sender: AnyObject) {
        print("here is the gesture")
        let velocity = sender.velocityInView(view)
        var direction : String!
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
        } else if sender.state == UIGestureRecognizerState.Ended {
            //UIView.animateWithDuration(0.3, animations: {
            if velocity.x > 0 {
                direction = "right"
            } else {
                direction = "left"
            }
            if velocity.y > 0 {
                direction = "top"
            } else {
                direction = "bottom"
            }
            let newController = self.getNewController(direction)
            if let newController = newController {
                currentViewController = newController
                self.showCurrentViewController();
            }
            self.view.layoutIfNeeded()
            // })
        }
    }
    

    func showCurrentViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(currentViewController)
        self.contentViewController = vc
    }
    
    
    func getNewController(direction : String) -> String? {
        var newViewController : String?
        if currentViewController == "DiscoverViewController" {
            switch direction {
            case "left":
                newViewController = "FavouritesViewController"
            case "right":
                newViewController = "ProfileViewController"
            case "top":
                newViewController = "MapsViewController"
            default:
                print("no where to go")
            }
        }
        if currentViewController == "FavouritesViewController" {
            switch direction {
            case "right":
                newViewController = "DiscoverViewController"
            default:
                print("no where to go")
            }
        }
        if currentViewController == "MapsViewController" {
            switch direction {
            case "left":
                newViewController = "FavouritesViewController"
            case "right":
                newViewController = "ProfileViewController"
            case "bottom":
                newViewController = "DiscoverViewController"
            default:
                print("no where to go")
            }
        }
        if currentViewController == "ProfileViewController" {
            switch direction {
            case "left":
                newViewController = "DiscoverViewController"
            default:
                print("no where to go")
            }
        }
        
        
        return newViewController
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
