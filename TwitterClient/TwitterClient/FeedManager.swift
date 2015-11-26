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
        if let tweetObjects = Tweet.allOrderedBy("id", ascending: false) as? [Tweet] {
            tweets = tweetObjects.map({TWTRTweet(JSONDictionary: $0.convertedToDictionary())})
            self.canLoadMore = true
        }
        if tweets.count == 0 {
            loadHomeTimeline({ (error) -> () in
                completion(error: error)
                guard let _ = error else {
                    self.canLoadMore = true
                    return
                }
            })
        } else {
            completion(error: nil)
        }
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
                        if let maxId = tweets.last?.tweetID, sinceId = tweets.first?.tweetID {
                            self.maxId = maxId
                            self.sinceId = sinceId
                        }
                        let ggg = tweetsObjects.map({ (obj) -> Tweet in
                            let tw = Tweet.safeCreateOrUpdateWithDictionary(obj)
                            if let urls = obj["entities"]?["urls"] as? [[NSObject:AnyObject]] {
//                                var newUrls:[Url] = []
                                for url in urls {
                                    let uuu = Url.safeCreateOrUpdateWithDictionary(url)
                                    uuu.tweet = tw
                                }
//                                tw.urls = NSSet(array: newUrls)
                            }
                            return tw
                        })
                        
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
                    if let data = data, /*let tweetsObjects = JSON(data: data).arrayObject as? [[NSObject:AnyObject]],*/ let tweets = TWTRTweet.tweetsWithJSONArray(JSON(data: data).arrayObject) as? [TWTRTweet] {
                        if let maxId = tweets.last?.tweetID {
                            self.maxId = maxId
                        }
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
                    if let data = data, /*let tweetsObjects = JSON(data: data).arrayObject as? [[NSObject:AnyObject]],*/ let tweets = TWTRTweet.tweetsWithJSONArray(JSON(data: data).arrayObject) as? [TWTRTweet] {
                        if let sinceId = tweets.first?.tweetID {
                            self.sinceId = sinceId
                        }
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