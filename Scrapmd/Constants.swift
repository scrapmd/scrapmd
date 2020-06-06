//
//  Constants.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation

let scrapDirectoryNameSuffix = ""
let scrapDirectoryNameMaxLength = 255 - scrapDirectoryNameSuffix.count
let markdownFilename = "content.md"
let metadataFilename = ".metadata.json"

extension JSONEncoder.DateEncodingStrategy {
    static var `default`: JSONEncoder.DateEncodingStrategy { .iso8601 }
}
