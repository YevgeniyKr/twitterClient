//
//  FeedManager.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 24.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation
import TwitterKit
import SwiftyJSON
import MAGCoreData

class FeedManager {
    var twitterManager = Twitter.sharedInstance()
    
    var count = 30
    var maxId: String?
    var sinceId: String?
    var tweets: [TWTRTweet] = [] {
        didSet {
            if let maxId = tweets.last?.tweetID, sinceId = tweets.first?.tweetID {
                self.maxId = maxId
                self.sinceId = sinceId
            }
        }
    }
    
    private var canLoadMore = false
    
    func getTimeline(completion: (error: NSError?)->())  {
//        self.tweets = self.cachedTimeline()
//        completion(error: nil)

        loadHomeTimeline({ (error) -> () in
            self.canLoadMore = true
            if let _ = error where self.tweets.count == 0 {
                self.tweets = self.cachedTimeline()
                print("using cached Timeline")
            } else {
                print("using new timeline")
            }
            completion(error: error)
        })
    }
    
    func cachedTimeline() -> [TWTRTweet] {
        let tweets = Tweet.cachedObjects()
        return tweets.map({TWTRTweet(JSONDictionary: $0.convertedToDictionary())})
    }
    
    func loadHomeTimeline(completion: (error: NSError?)->()) {
        if let userID = twitterManager.sessionStore.session()?.userID {
            let params:[String: AnyObject] = ["count": String(count)]
            RequestManager.getHomeTimeline(forUserWithUserID: userID, parameters: params) { (response, data, error) -> () in
                if let error = error {
                    completion(error: error)
                } else {
                    //FIXME: add apropriete error handling here, like for 4xx, 5xx statuses
                    //FIXME: temporary we suggest that we can't have such errors
                    if let data = data, let tweetsObjects = JSON(data: data).arrayObject as? [[NSObject:AnyObject]], let tweets = TWTRTweet.tweetsWithJSONArray(JSON(data: data).arrayObject) as? [TWTRTweet] {
                        
                        _ = tweetsObjects.map({Tweet.createFromJSONDictionary($0)})
                        MAGCoreData.save()
                        
                        self.tweets = tweets
                        completion(error: nil)
                    } else {
                        completion(error: NSError.errorWithLocalizedDescription("Response Error"))
                    }
                }
            }
        } else {
            completion(error: NSError.errorWithLocalizedDescription(NSLocalizedString("NoUserError", comment: "")))
        }
    }
    
    func loadMoreHomeTimeline(completion: (error: NSError?)->()) {
        if let userID = twitterManager.sessionStore.session()?.userID, maxId = maxId where canLoadMore {
            canLoadMore = false
            print("started load more")
            let params:[String: AnyObject] = ["count": String(count), "max_id": maxId]
            RequestManager.getHomeTimeline(forUserWithUserID: userID, parameters: params) { (response, data, error) -> () in
                self.canLoadMore = true
                print("finished load more")
                if let error = error {
                    completion(error: error)
                } else {
                    if let data = data, let tweetsObjects = JSON(data: data).arrayObject as? [[NSObject:AnyObject]], let tweets = TWTRTweet.tweetsWithJSONArray(JSON(data: data).arrayObject) as? [TWTRTweet] {
                        
                        _ = tweetsObjects.map({Tweet.createFromJSONDictionary($0)})
                        MAGCoreData.save()

                        var newTweets = tweets
                        newTweets.removeAtIndex(0)
                        self.tweets.appendContentsOf(newTweets)
                        completion(error: nil)
                    } else {
                        completion(error: NSError.errorWithLocalizedDescription("Response Error"))
                    }
                }
            }
        }
    }
    
    func loadNewTweetsFromTimeline(completion: (error: NSError?)->()) {
        if let userID = twitterManager.sessionStore.session()?.userID, sinceId = sinceId {
            print("started load new")
            let params:[String: AnyObject] = ["count": String(count), "since_id": sinceId]
            RequestManager.getHomeTimeline(forUserWithUserID: userID, parameters: params) { (response, data, error) -> () in
                print("finished load new")
                if let error = error {
                    completion(error: error)
                } else {
                    if let data = data, let tweetsObjects = JSON(data: data).arrayObject as? [[NSObject:AnyObject]], let tweets = TWTRTweet.tweetsWithJSONArray(JSON(data: data).arrayObject) as? [TWTRTweet] {
                        
                        _ = tweetsObjects.map({Tweet.createFromJSONDictionary($0)})
                        MAGCoreData.save()

                        let newTweets = tweets
                        self.tweets.insertContentsOf(newTweets, at: 0)
                        completion(error: nil)
                    } else {
                        completion(error: NSError.errorWithLocalizedDescription("Response Error"))
                    }
                }
            }
        }
    }
}