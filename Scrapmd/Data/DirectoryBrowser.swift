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
    @Published var path: Path? {
        didSet {
            self.update()
            self.updateMonitor()
        }
    }

    init(onlyDirectory: Bool) {
        self.onlyDirectory = onlyDirectory
        self.items = []
    }

    private var monitor: DispatchSourceFileSystemObject?

    deinit {
        monitor?.cancel()
    }

    func updateMonitor() {
        monitor?.cancel()
        monitor = nil
        guard let path = path else { return }
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
        guard let items = (path?.children(recursive: false))?
            .filter({ p in
                !p.isHidden && p.isDirectory &&
                    ((self.onlyDirectory && !p.isScrap) || !self.onlyDirectory)
            }) else { return }
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
