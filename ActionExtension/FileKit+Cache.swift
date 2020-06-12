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

extension Path {
    static func createBackgroundContext() -> NSManagedObjectContext? {
        return nil
    }

    func cache(createdAt: Date, in context: NSManagedObjectContext) {}

    var cachedCreatedAt: Date? {
        return nil
    }
}
