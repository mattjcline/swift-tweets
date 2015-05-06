//
//  TwitterClient.swift
//  Twitter
//
//  Created by Matt Cline on 5/1/15.
//  Copyright (c) 2015 Matt Cline. All rights reserved.
//

import UIKit

let twitterConsumerKey = "A0SJqB8UoMFuw0ZeEIliaQpMj"
let twitterConsumerSecret = "PiAho5hY8wQJnhkBGZ1487zWD4fDRpQYGDaI8VyHPAbaP9iesP"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("home_timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
//            for tweet in tweets {
//                println("\(tweet)")
//            }
            
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "swifttweets://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            var authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authUrl!)
            }) { (error: NSError!) -> Void in
                println("error!")
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("user: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                println("user: \(user.name)")
                
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error: NSError!) -> Void in
                println("failed to receive")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func postTweet(params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error tweeting")
                completion(error: error)
            }
        )}
    
    func favoriteTweet(id: Int, completion: (tweet: Tweet?, error: NSError?) -> () ){
        let params = ["id": id]
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error favoriting")
                println(error)
                completion(tweet: nil, error: error)
            }
        )}
    
    func unfavoritetweet(id: Int, completion: (tweet: Tweet?, error: NSError?) -> () ){
        let params = ["id": id]
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error un-favoriting")
                completion(tweet: nil, error: error)
        }
    )}
    
    
    func retweetTweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        let params = ["id": id]
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error retweeting")
                completion(error: error)
            }
        )}

    func unRetweetTweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        let params = ["id": id]
        POST("1.1/statuses/destroy/\(id).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error un-retweeting")
                completion(error: error)
            }
        )}
    
}
