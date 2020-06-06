//
//  FileKitExtension.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import FileKit

typealias FileKitPath = Path

extension Path {
    static var iCloudDocuments: Path? {
        if
            let url = FileManager.default.url(forUbiquityContainerIdentifier: nil),
            let path = Path(url: url) {
            return path + "Documents"
        }
        return nil
    }
}

extension Path: Identifiable {
    public var id: String {
        return self.rawValue
    }
}
