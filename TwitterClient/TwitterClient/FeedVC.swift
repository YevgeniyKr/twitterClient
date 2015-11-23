//
//  FeedVC.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 20.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import UIKit
import TwitterKit

class FeedVC: UIViewController {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logoutAction(sender: AnyObject) {
        let store = Twitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
            NSNotificationCenter.defaultCenter().postNotificationName(ApplicationFlowManager.AppFlowNotifications.UserLoggedOut.rawValue, object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeed()
    }

    func loadFeed() {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            let params = ["count": "1"]
            
            let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: nil)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    do {
                        if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [AnyObject], tweetJson = json[0] as? [String:AnyObject] {
                            let tweet = TWTRTweet(JSONDictionary: tweetJson)
//                            print(json)
//                            print(tweet)
                        }
                    } catch {
                        print(error)
                    }
                }
                else {
                    print("Error: \(connectionError)")
                }
            }
        }
    }
}