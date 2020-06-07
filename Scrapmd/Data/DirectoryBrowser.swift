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

fileprivate var queueId = 0

class DirectoryBrowser: ObservableObject {
    let onlyDirectory: Bool
    @Published var items: [Path]
    let path: Path

    init(_ path: Path, onlyDirectory: Bool) {
        self.onlyDirectory = onlyDirectory
        self.items = []
        self.path = path
        update()
        updateMonitor()
    }

    private var monitor: DispatchSourceFileSystemObject?

    deinit {
        monitor?.cancel()
    }

    func updateMonitor() {
        monitor?.cancel()
        monitor = nil
        let descriptor = open(path.rawValue, O_EVTONLY)
        queueId += 1
        let queue = DispatchQueue(label: "app.scrapmd.directoryBrowser-\(queueId)")
        let monitor = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: .write, queue: queue)
        monitor.setEventHandler { [weak self] in
            self?.update()
        }
        monitor.activate()
        self.monitor = monitor
    }

    func update() {
        let items = path.children(recursive: false)
            .filter({ p in
                !p.isHidden && p.isDirectory &&
                    ((self.onlyDirectory && !p.isScrap) || !self.onlyDirectory)
            })
        DispatchQueue.main.async {
            self.items = items
        }
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { offset in
            let itemsToDelete = items[offset]
            do {
                try itemsToDelete.deleteFile()
            } catch {
                print(error)
            }
        }
    }
}
