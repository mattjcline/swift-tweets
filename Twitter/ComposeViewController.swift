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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissComposeModal()
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        var params = NSDictionary()
        params = ["status": compositionTextView.text!]
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
