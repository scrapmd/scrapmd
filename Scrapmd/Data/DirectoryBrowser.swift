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

private var queueId = 0

class DirectoryBrowser: ObservableObject {
    class Item: ObservableObject, Identifiable, Hashable {
        @Published var metadata: ScrapMetadata?
        @Published var thumbnail: UIImage?

        static func == (lhs: DirectoryBrowser.Item, rhs: DirectoryBrowser.Item) -> Bool {
            lhs.path == rhs.path
        }

        let path: Path
        init(_ path: Path) {
            self.path = path
            self.metadata = path.metadata
            self.thumbnail = path.thumbnail
        }
        var id: String {
            path.id
        }

        func hash(into hasher: inout Hasher) {
            self.path.hash(into: &hasher)
        }
    }
    let onlyDirectory: Bool
    @Published var items: [Item]
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
        let monitor = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: .all, queue: queue)
        monitor.setEventHandler { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self?.update()
            }
        }
        monitor.activate()
        self.monitor = monitor
    }

    func update() {
        self.items = self.path.children(recursive: false)
            .filter({ p in
                !p.isHidden && p.isDirectory &&
                    ((self.onlyDirectory && !p.isScrap) || !self.onlyDirectory)
            }).map { Item($0) }
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { offset in
            do {
                try items[offset].path.deleteFile()
            } catch {
                print(error)
            }
        }
    }
}
