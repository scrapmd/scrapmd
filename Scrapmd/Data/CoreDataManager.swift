//
//  CoreDataManager.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import CoreData
import FileKit

struct CoreDataManager {
    static var shared = CoreDataManager()
    static let defaultMergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)

    // MARK: - Core Data stack

    mutating func newBackgroundContext() -> NSManagedObjectContext {
        let ctx = persistentContainer.newBackgroundContext()
        ctx.mergePolicy = CoreDataManager.defaultMergePolicy
        return ctx
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let dbName = "Scrapmd"
        let container = NSPersistentContainer(name: dbName)
        let url = (Path(groupIdentifier: suiteName)! + "\(dbName).sql").url
        let storeDescription = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                log(error: error)
                fatalError("Unresolved error \(error), \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    mutating func saveContext () {
        let context = persistentContainer.viewContext
        context.mergePolicy = CoreDataManager.defaultMergePolicy
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
