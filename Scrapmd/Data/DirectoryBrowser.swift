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
        @Published var scrapsCount: Int
        @Published var foldersCount: Int
        @Published var fileName: String

        static func == (lhs: DirectoryBrowser.Item, rhs: DirectoryBrowser.Item) -> Bool {
            lhs.id == rhs.id
        }

        let path: Path

        init(_ path: Path) {
            self.path = path
            self.metadata = path.metadata
            self.thumbnail = path.thumbnail
            self.scrapsCount = path.scrapsCount
            self.foldersCount = path.foldersCount
            self.fileName = path.fileName
        }

        var id: String { // swiftlint:disable:this identifier_name
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
        self.items = self.path.children(recursive: false)
            .filter({ path in
                !path.isHidden && path.isDirectory &&
                    ((self.onlyDirectory && !path.isScrap) || !self.onlyDirectory)
            }).map { Item($0) }
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
}
