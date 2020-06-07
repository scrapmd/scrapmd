//
//  URLExtension.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    var isValidWebURL: Bool {
        (scheme == "http" || scheme == "https") && host != nil && !host!.isEmpty
    }
}
