//
//  User.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 26.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
class User: NSManagedObject {

    override class func initialize() {
        super.initialize()
        setPrimaryKeyName("id")
        setDefaultDateFormat("EEE MMM d HH:mm:ss ZZZ yyyy")
        setKeyMapping(
            [
                "id": "id",
                "screenName": "screen_name",
                "name": "name",
                "profileImageURLHTTPS": "profile_image_url_https",
                "profileImageURL": "profile_image_url_https",
            ])
    }
}
