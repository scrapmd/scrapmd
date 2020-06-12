//
//  FileKit+Cache.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import FileKit
import CoreData
import UIKit

extension Path {
    static func createBackgroundContext() -> NSManagedObjectContext? {
        return NSPersistentContainer.shared?.newBackgroundContext()
    }

    func cache(createdAt: Date, in context: NSManagedObjectContext) {
        if self == .userDocuments || self == Path.iCloudDocuments {
            return
        }
        let found = TimestampCache.findOrCreate(by: self, in: context)
        found.createdAt = createdAt
        self.parent.cache(createdAt: createdAt, in: context)
    }

    var cachedCreatedAt: Date? {
        guard let context = NSPersistentContainer.shared?.viewContext else {
            return nil
        }
        return TimestampCache.findOrCreate(by: self, in: context).createdAt
    }
}
