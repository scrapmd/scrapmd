//
//  Constants.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation

let scrapDirectoryNameSuffix = ".scrapmd"
let scrapDirectoryNameMaxLength = 255 - scrapDirectoryNameSuffix.count
let markdownFilename = "content.md"
let metadataFilename = "metadata.json"
let thumbnailPath = "img/thumbnail.png"

let displayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()


extension JSONEncoder.DateEncodingStrategy {
    static var `default`: JSONEncoder.DateEncodingStrategy { .iso8601 }
}

extension JSONDecoder.DateDecodingStrategy {
    static var `default`: JSONDecoder.DateDecodingStrategy { .iso8601 }
}
