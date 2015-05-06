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
    
    @IBOutlet weak var profileImageView: UIImageView!
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
            self.profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2
            self.profileImageView.clipsToBounds = true

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
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let composeViewController = navigationController.topViewController as? ComposeViewController {
                composeViewController.replyTo = self.tweet
            }
        }
    }

}
