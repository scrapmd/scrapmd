//
//  ScrapMeatadata.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/06.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation

struct ScrapMetadata: Codable {
    var title: String
    var url: String
    var createdAt: Date
    var appVersion: String
}
