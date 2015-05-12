//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Matt Cline on 5/3/15.
//  Copyright (c) 2015 Matt Cline. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    static let replyIcon = UIImage(named: "reply.png")
    static let retweetIcon = UIImage(named: "retweet.png")
    static let favoriteIcon = UIImage(named: "favorite.png")
    


    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTweetDetailView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavoriteButtonPressed(sender: AnyObject) {
        if let tweet = tweet {
            if tweet.favorited {
                TwitterClient.sharedInstance.unfavoritetweet(tweet.id!, completion: { (tweet, error) -> () in
                    if let tweet = tweet {
                        self.tweet!.favoritesCount = tweet.favoritesCount
                        self.tweet!.favorited = tweet.favorited
                    }
                })
            } else {
                TwitterClient.sharedInstance.favoriteTweet(tweet.id!, completion: { (tweet, error) -> () in
                    if let tweet = tweet {
                        self.tweet!.favoritesCount = tweet.favoritesCount
                        self.tweet!.favorited = tweet.favorited
                    }
                })
            }
        }
    }
    
    
    func initTweetDetailView() {
        if let tweet = tweet, user = tweet.user {
            self.tweetBodyLabel.text = tweet.text
            self.createdAtLabel.text = tweet.createdAtString
            self.fullNameLabel.text = user.name
            self.usernameLabel.text = "@\(user.screenname!)"
            self.profileImageButton.setBackgroundImageForState(.Normal, withURL: NSURL(string: user.profileImageUrl!))
            self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height / 2
            self.profileImageButton.clipsToBounds = true
            self.replyButton.setImage(TweetDetailViewController.replyIcon, forState: .Normal)
            self.retweetButton.setImage(TweetDetailViewController.retweetIcon, forState: .Normal)
            self.favoriteButton.setImage(TweetDetailViewController.favoriteIcon, forState: .Normal)
            self.retweetCountLabel.text = "\(tweet.retweetsCount ?? 0)"
            self.favoriteCountLabel.text = "\(tweet.favoritesCount ?? 0)"
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nc = segue.destinationViewController as? UINavigationController {
            var composeViewController = nc.topViewController as? ComposeViewController
            var profileViewController = nc.topViewController as? ProfileViewController

            // reply
            if let composeViewController = composeViewController {
                println("compose view")
                composeViewController.replyTo = self.tweet
            }
        
            // profile
            if let profileViewController = profileViewController {
                profileViewController.user = self.tweet!.user
                println("profile view")
                println(self.tweet!.user)
            }
        }
    }

}
