//
//  TweetPoster.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 02.12.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation

class TweetPoster: NSOperation {
    let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    override var asynchronous: Bool {
        return false
    }
    
    private var _executing: Bool = false;
    override var executing: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValueForKey("isExecuting")
                _executing = newValue
                didChangeValueForKey("isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var finished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValueForKey("isFinished")
                _finished = newValue
                didChangeValueForKey("isFinished")
            }
        }
    }
    
    override func start() {
        if cancelled {
            finished = true
            return
        }
        
        executing = true
        FeedManager.sendPostTweetRequest(withText: tweet.text ?? "", completion: { (error) -> () in
            if error == nil {
                self.tweet.delete()
                MAGCoreData.save()
            }
            self.finish()
        })
    }
    
    func finish() {
        executing = false
        finished = true
    }
}