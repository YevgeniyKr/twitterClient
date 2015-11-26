//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var profileImageLargeURL: String?
    @NSManaged var profileImageMiniURL: String?
    @NSManaged var profileImageURL: String?
    @NSManaged var screenName: String?
    @NSManaged var tweets: NSSet?

}
