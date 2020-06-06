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

class JSONFile<T: Codable>: DataFile {
    func read() throws -> T {
        let data = try super.read()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .default
        return try decoder.decode(T.self, from: data)
    }
}

extension Path {
    static var iCloudDocuments: Path? {
        if
            let url = FileManager.default.url(forUbiquityContainerIdentifier: nil),
            let path = Path(url: url) {
            return path + "Documents"
        }
        return nil
    }

    var isHidden: Bool {
        isDotfile || (isScrap && !metadataFile.exists)
    }

    var isScrap: Bool {
        fileName.hasSuffix(scrapDirectoryNameSuffix)
    }

    var isDotfile: Bool {
        fileName.starts(with: ".")
    }

    var foldersCount: Int {
        children().filter({ !$0.isHidden && !$0.isScrap && $0.isDirectory }).count
    }

    var scrapsCount: Int {
        children().filter({ !$0.isHidden && $0.isScrap }).count
    }

    var metadataFile: JSONFile<ScrapMetadata> {
        JSONFile<ScrapMetadata>(path: self + metadataFilename)
    }

    var metadata: ScrapMetadata? {
        return metadataFile.exists ? try? metadataFile.read() : nil
    }

    var thumbnail: Image {
        let file = ImageFile(path: self + thumbnailPath)
        let img = file.exists ? try? file.read() : nil
        return img ?? Image(systemName: "photo")!
    }
}

extension Path: Identifiable {
    public var id: String {
        return self.rawValue
    }
}
