//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Matt Cline on 5/3/15.
//  Copyright (c) 2015 Matt Cline. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var compositionTextView: UITextView!
    
    var params: NSMutableDictionary!
    var replyTo: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let replyTo = replyTo {
            compositionTextView.text = "@\(replyTo.user!.screenname!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        replyTo = nil
        dismissComposeModal()
    }
    
    @IBAction func onTweetButtonPressed(sender: AnyObject) {
        params = ["status": compositionTextView.text!]
        
        if let tweet = replyTo, user = replyTo!.user {
            params.setValue("\(tweet.id!)", forKey: "in_reply_to_status_id")
            params.setValue("\(user.id!)", forKey: "in_reply_to_user_id")
            println("replied to ID: \(tweet.id!)\nreplied to user ID: \(user.id!)")
        }
        
        TwitterClient.sharedInstance.postTweet(params, completion: { (error) -> () in
            self.dismissComposeModal()
        })
    }
    
    func dismissComposeModal() {
        self.dismissViewControllerAnimated(true, completion: {});
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
