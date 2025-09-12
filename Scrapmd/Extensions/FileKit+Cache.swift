//
//  FileKit+Cache.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import CoreData
import FileKit
import Foundation
import UIKit

extension Path {
    func cache(createdAt: Date, in context: NSManagedObjectContext) {
        if self.isRoot || self.rawValue == "/" {
            return
        }
        let found = TimestampCache.findOrCreate(by: self, in: context)
        found.createdAt = createdAt
        self.parent.cache(createdAt: createdAt, in: context)
    }

    var cachedCreatedAt: Date? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        return TimestampCache.findOrCreate(by: self, in: context).createdAt
    }
}
