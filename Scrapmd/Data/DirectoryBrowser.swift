//
//  DirectoryBrowser.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import Combine
import FileKit
import Dispatch
import UIKit
import SwiftUI

private var queueId = 0

class DirectoryBrowser: ObservableObject {
    let onlyDirectory: Bool
    @Published var items: [Item]
    let path: FileKitPath
    let sort: Sort

    enum Sort {
        case created
        case name
    }

    init(_ path: FileKitPath, onlyDirectory: Bool, sort: Sort) {
        self.onlyDirectory = onlyDirectory
        self.items = []
        self.path = path
        self.sort = sort
        self.items = fetchItems()
        updateMonitor()
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateDirectory, object: nil)
    }

    private var monitor: DispatchSourceFileSystemObject?

    deinit {
        monitor?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    func updateMonitor() {
        monitor?.cancel()
        monitor = nil
        let descriptor = open(path.rawValue, O_EVTONLY)
        queueId += 1
        let queue = DispatchQueue(label: "app.scrapmd.directoryBrowser-\(queueId)")
        let monitor = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor, eventMask: .all, queue: queue)
        monitor.setEventHandler { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self?.update()
            }
        }
        monitor.activate()
        self.monitor = monitor
    }

    @objc func update() {
        let queue = DispatchQueue(label: "app.scrapmd.directoryBrowser-\(queueId)")
        queueId += 1
        queue.async {
            let items = self.fetchItems()
            DispatchQueue.main.async {
                self.items = items
            }
        }
    }

    func fetchItems() -> [Item] {
        return self.path.children(recursive: false)
        .filter({ path in
            !path.isHidden && path.isDirectory &&
                ((self.onlyDirectory && !path.isScrap) || !self.onlyDirectory)
        }).sorted(by: {
            if
                self.sort == .created,
                let date1 = $0.createdAt,
                let date2 = $1.createdAt {
                return date1 > date2
            }
            return $0.fileName < $1.fileName
        }) .map { Item($0) }
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { offset in
            do {
                try items[offset].path.deleteFile()
                items.remove(at: offset)
            } catch {
                print(error)
            }
        }
        FileManager.default.sync()
        NotificationCenter.default.post(Notification(name: .updateDirectory))
    }

    var sectionedIndices: [(String, [Range<Int>.Element])] {
        Dictionary(grouping: self.items.indices) {
            if let date = self.items[$0].path.createdAt {
                return sectionDateFormatter.string(from: date)
            }
            return ""
        }.map { ($0, $1) }.sorted(by: {
            if
                let date1 = self.items[$0.1[0]].path.createdAt,
                let date2 = self.items[$1.1[0]].path.createdAt {
                return date1 > date2
            }
            if self.items[$0.1[0]].path.createdAt != nil {
                return true
            }
            return false
        })
    }
}
