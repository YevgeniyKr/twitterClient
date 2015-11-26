//
//  Url.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 26.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation
import CoreData

@objc(Url)
class Url: NSManagedObject {

    override class func initialize() {
        super.initialize()
        setPrimaryKeyName("url")
        setKeyMapping(
            [
                "url": "url",
                "displayUrl": "display_url",
                "expandedUrl": "expanded_url",
            ])
    }
}