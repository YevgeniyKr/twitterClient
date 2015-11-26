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
//            if let urls = urls?.allObjects {
                for url1 in urls?.allObjects ?? [] {
                    if let url2 = url1 as? Url {
                        urlsDict.append([
                            "display_url" : url2.displayUrl ?? "",
                            "url" : url2.url ?? "",
                            "expanded_url" : url2.expandedUrl ?? ""
                            ])
                    }
                }
//            }
            
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

}
