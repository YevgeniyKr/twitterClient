//
//  RequestManager.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 24.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation
import TwitterKit

class RequestManager {
    class func getHomeTimeline(forUserWithUserID userID: String, parameters: [String:AnyObject], completion: (response:NSURLResponse?, data: NSData?, error: NSError?)->()) {
        let client = TWTRAPIClient(userID: userID)
        let endpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: endpoint, parameters: parameters, error: nil)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            completion(response: response, data: data, error: connectionError)
        }
    }
    
    class func postTweet(forUserWithUserID userID: String, parameters: [String:AnyObject], completion: (response:NSURLResponse?, data: NSData?, error: NSError?)->()) {
        let client = TWTRAPIClient(userID: userID)
        let endpoint = "https://api.twitter.com/1.1/statuses/update.json"
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: endpoint, parameters: parameters, error: nil)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            completion(response: response, data: data, error: connectionError)
        }
    }
}