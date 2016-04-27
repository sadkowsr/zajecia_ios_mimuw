//
//  Trend+CoreDataProperties.swift
//  TwitterTrends
//
//  Created by Kajetan Dąbrowski on 27/04/16.
//  Copyright © 2016 DaftMobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trend {

    @NSManaged var url: String?
    @NSManaged var name: String?
    @NSManaged var tweetVolume: NSNumber?
    @NSManaged var query: String?

}
