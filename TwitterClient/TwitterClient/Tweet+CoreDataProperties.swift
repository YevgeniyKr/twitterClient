//
//  Tweet+CoreDataProperties.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 28.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var createdAt: String?
    @NSManaged var id: String?
    @NSManaged var permalink: String?
    @NSManaged var requireSending: NSNumber?
    @NSManaged var text: String?
    @NSManaged var localCreationDate: NSDate?
    @NSManaged var author: User?
    @NSManaged var urls: NSSet?

}
