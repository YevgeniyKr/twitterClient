//
//  Url+CoreDataProperties.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 26.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Url {

    @NSManaged var displayUrl: String?
    @NSManaged var expandedUrl: String?
    @NSManaged var url: String?
    @NSManaged var tweet: Tweet?

}
