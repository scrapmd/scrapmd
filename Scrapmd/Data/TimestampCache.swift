//
//  TimestampCache.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension TimestampCache {
    static func find(by path: FileKitPath, in context: NSManagedObjectContext) -> TimestampCache? {
        let req = NSFetchRequest<TimestampCache>(entityName: "TimestampCache")
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "path = %@", path.rawValue)
        return try? context.fetch(req).first
    }

    static func findOrCreate(by path: FileKitPath, in context: NSManagedObjectContext) -> TimestampCache {
        if let found = find(by: path, in: context) {
            return found
        }
        let cache = self.init(context: context)
        cache.path = path.rawValue
        cache.parent = self.findOrCreate(by: path.parent, in: context)
        return cache
    }
}
