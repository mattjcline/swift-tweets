//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Matt Cline on 5/8/15.
//  Copyright (c) 2015 Matt Cline. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var listedLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfileView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initProfileView() {
        if let user = user {
            self.profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2
            self.profileImageView.clipsToBounds = true
            self.backgroundImageView.setImageWithURL(NSURL(string: user.backgroundImageUrl!))
            self.bioLabel.text = user.bio
            self.nameLabel.text = user.name
            self.usernameLabel.text = "@\(user.screenname!)"
            self.followersLabel.text = "\(user.followerCount! ?? 0) Followers"
            self.followingLabel.text = "\(user.followingCount! ?? 0) Following"
            self.favoritesLabel.text = "\(user.favoritesCount! ?? 0) Favorites"
            self.listedLabel.text = "\(user.listedCount! ?? 0) Listed"
        }
    }
    
    @IBAction func onBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
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
