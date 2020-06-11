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

    var markdownFile: TextFile {
        TextFile(path: self + markdownFilename)
    }

    var metadata: ScrapMetadata? {
        return metadataFile.exists ? try? metadataFile.read() : nil
    }

    var thumbnailFile: ImageFile {
        ImageFile(path: self + thumbnailPath)
    }

    var thumbnail: Image {
        let img = thumbnailFile.exists ? try? thumbnailFile.read() : nil
        return img ?? Image(named: "NoImg")!
    }

    func fileURL(scheme: String? = nil) -> URL {
        var urlComponents = URLComponents()
        urlComponents.path = rawValue
        urlComponents.host = ""
        if let scheme = scheme {
            urlComponents.scheme = scheme
        } else {
            #if !targetEnvironment(macCatalyst)
            urlComponents.scheme = "file"
            #else
            urlComponents.scheme = "shareddocuments"
            #endif
        }
        return urlComponents.url!
    }
}

extension Path: Identifiable {
    public var id: String { // swiftlint:disable:this identifier_name
        return "\(self.rawValue) \(self.scrapsCount) \(self.foldersCount)".data(using: .utf8)!.base64EncodedString()
    }
}
