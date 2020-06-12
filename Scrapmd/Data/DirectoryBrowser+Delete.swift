//
//  DirectoryBrowser+Delete.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import CoreData

extension DirectoryBrowser {
    func delete(at offsets: IndexSet) {
        cancelUpdate()
        let pathes = offsets.map { offset -> FileKitPath in
            let path = items[offset].path
            do {
                try path.deleteFile()
            } catch {
                print(error)
            }
            return path
        }

        CoreDataManager.shared.persistentContainer.performBackgroundTask { context in
            pathes.forEach { path in
                if let found = TimestampCache.find(by: path, in: context) {
                    context.delete(found)
                }
            }
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        items.remove(atOffsets: offsets)
        FileManager.default.sync()
        NotificationCenter.default.post(Notification(name: .updateDirectory))
    }
}
