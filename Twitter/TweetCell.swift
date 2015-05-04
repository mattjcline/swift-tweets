//
//  TweetCell.swift
//  Twitter
//
//  Created by Matt Cline on 5/3/15.
//  Copyright (c) 2015 Matt Cline. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var tweet: Tweet? {
        willSet(data) {
            self.tweetBodyLabel.text = data?.text
            self.timeSinceLabel.text = data?.createdAt?.timeAgo()
            if let user = data?.user {
                self.fullNameLabel.text = user.name
                self.usernameLabel.text = "@\(user.screenname!)"
                self.profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
                self.replyImageView.image = UIImage(named: "reply")
                self.favoriteImageView.image = UIImage(named: "favorite")
                self.retweetImageView.image = UIImage(named: "retweet")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // round the icons
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
