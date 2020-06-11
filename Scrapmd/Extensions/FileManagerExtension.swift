//
//  FileManagerExtension.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation

extension FileManager {
    func sync() {
        if let url = FileKitPath.iCloudDocuments?.url {
            try? self.startDownloadingUbiquitousItem(at: url)
        }
    }
}
