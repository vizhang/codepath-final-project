//
//  ProfileViewController.swift
//  columbus
//
//  Created by Victor Zhang on 10/11/15.
//  Copyright © 2015 Victor Zhang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User.currentUser
        if let pp = user?.profile_picture {
            profileImageView.setImageWithURL( NSURL(string: pp))
            profileImageView.layer.cornerRadius = 3
            profileImageView.clipsToBounds = true
        }
        usernameLabel.text = user?.username
        bioLabel.text = user?.bio

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onSignOutPressed(sender: AnyObject) {
        print("sign out pressed")
        User.currentUser?.logout()

    }
}
