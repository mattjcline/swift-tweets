//
//  Tweet.swift
//  Twitter
//
//  Created by Matt Cline on 5/1/15.
//  Copyright (c) 2015 Matt Cline. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favorited: Bool = false
    var retweeted: Bool = false
    var retweetsCount: Int?
    var favoritesCount: Int?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favorited = dictionary["favorited"] as? Bool ?? false
        retweeted = dictionary["retweeted"] as? Bool ?? false
        retweetsCount = dictionary["retweet_count"] as? Int
        favoritesCount = dictionary["favorites_count"] as? Int
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
}
