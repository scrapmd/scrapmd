//
//  DirectoryBrowser.Item.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import Combine
import FileKit
import UIKit

extension DirectoryBrowser {
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
}
