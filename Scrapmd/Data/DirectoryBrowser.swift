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

class DirectoryBrowser: ObservableObject {
    @Published var items: [Path] = []
    @Published var onlyDirectory: Bool = false
    @Published var path: Path? = nil {
        didSet {
            self.updateMonitor()
            self.update()
        }
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
        let queue = DispatchQueue(label: "app.scrapmd.directoryBrowser")
        let monitor = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: .write, queue: queue)
        monitor.setEventHandler { [weak self] in
            self?.update()
        }
        monitor.activate()
        self.monitor = monitor
    }
    
    func update() {
        let items = (self.path?.children(recursive: false) ?? [])
            .filter { !$0.isHidden && $0.isDirectory && (!self.onlyDirectory || $0.metadataFile.exists) }
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
