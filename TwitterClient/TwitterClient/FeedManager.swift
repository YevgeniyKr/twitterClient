//
//  FeedManager.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 24.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation
import TwitterKit

class FeedManager {
    var twitterManager = Twitter.sharedInstance()
    
    var count = 20
    var maxId: Int?
    var sinceId: Int?
    
    func loadHomeTimeline() {
        if let userID = twitterManager.sessionStore.session()?.userID {
            let params:[String: AnyObject] = ["count": String(count)]
            RequestManager.getHomeTimeline(forUserWithUserID: userID, parameters: params) { (response, data, error) -> () in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    //FIXME: add apropriete error handling here, like for 4xx, 5xx statuses
                    //FIXME: temporary we suggest that we can't have such errors
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
            }
        }
    }
}