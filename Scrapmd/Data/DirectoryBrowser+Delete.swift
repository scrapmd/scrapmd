//
//  DirectoryBrowser+Delete.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import CoreData
import FirebaseCrashlytics

extension DirectoryBrowser {
    func delete(at offsets: IndexSet) {
        cancelUpdate()
        let pathes = offsets.map { offset -> FileKitPath in
            let path = items[offset].path
            do {
                try path.deleteFile()
            } catch {
                print(error)
                Crashlytics.crashlytics().record(error: error)
            }
            return path
        }

        let context = CoreDataManager.shared.newBackgroundContext()
        context.perform {
            pathes.forEach { path in
                if let found = TimestampCache.find(by: path, in: context) {
                    context.delete(found)
                }
            }
            do {
                try context.save()
            } catch {
                print(error)
                Crashlytics.crashlytics().record(error: error)
            }
            do {
                try context.save()
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
        items.remove(atOffsets: offsets)
        FileManager.default.sync()
        NotificationCenter.default.post(Notification(name: .updateDirectory))
    }
}
