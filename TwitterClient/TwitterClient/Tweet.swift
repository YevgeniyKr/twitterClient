//
//  Tweet.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 25.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation
import CoreData

@objc(Tweet)
class Tweet: NSManagedObject {

    override class func initialize() {
        super.initialize()

        setPrimaryKeyName("id")
        setDefaultDateFormat("EEE MMM d HH:mm:ss ZZZ yyyy")
        setKeyMapping(
            [
                "id": "id",
                "text": "text",
                "createdAt": "created_at",
                "author": "user",
                "urls": "entities.urls"
            ])
        setRelationClasses(["author": User.self, "urls": Url.self])
    }

    func convertedToDictionary() -> [NSObject:AnyObject] {
        var resultDict: [NSObject:AnyObject] = [:]
        if let id = id, author = author {
            var urlsDict:[[NSObject:AnyObject]] = []
            for url in urls?.allObjects ?? [] {
                if let url = url as? Url {
                    urlsDict.append([
                        "display_url" : url.displayUrl ?? "",
                        "url" : url.url ?? "",
                        "expanded_url" : url.expandedUrl ?? ""
                        ])
                }
            }
            
            resultDict = [
                "id_str": id,
                "text": text ?? "",
                "created_at": createdAt ?? "",
                "user" : [
                    "id_str": author.id ?? "",
                    "screen_name": author.screenName ?? "",
                    "name": author.name ?? "",
                    "profile_image_url": author.profileImageURL ?? "",
                    "profile_image_url_https": author.profileImageURL ?? ""
                ],
                "entities": [
                    "urls": urlsDict
                ]
            ]
        }
        return resultDict
    }

    class func createFromJSONDictionary(dictionary: [NSObject:AnyObject]) -> Tweet {
        let tweet = Tweet.safeCreateOrUpdateWithDictionary(dictionary)
        if let urls = dictionary["entities"]?["urls"] as? [[NSObject:AnyObject]] {
            for url in urls {
                let newUrl = Url.safeCreateOrUpdateWithDictionary(url)
                newUrl.tweet = tweet
            }
        }
        return tweet
    }
    
    class func cachedObjects() -> [Tweet] {
        var tweets: [Tweet] = []
        let predicate = NSPredicate(format: "requireSending == NO")
        if let tweetObjects = Tweet.allForPredicate(predicate, orderBy: "id", ascending: false) as? [Tweet] {
            tweets = tweetObjects
        }
        return tweets
    }
    
    class func cachedForSending() -> [Tweet] {
        var tweets: [Tweet] = []
        let predicate = NSPredicate(format: "requireSending == YES")
        if let tweetObjects = Tweet.allForPredicate(predicate, orderBy: "localCreationDate", ascending: false) as? [Tweet] {
            tweets = tweetObjects
        }
        return tweets
    }
    
    class func firstForSending() -> Tweet? {
        let predicate = NSPredicate(format: "requireSending == YES")
        if let tweet = Tweet.firstForPredicate(predicate, orderBy: "localCreationDate", ascending: false) as? Tweet {
            return tweet
        }
        return nil
    }
}
