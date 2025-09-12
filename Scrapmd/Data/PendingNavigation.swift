//
//  PendingNavigation.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Combine
import Foundation

@MainActor
@Observable
class PendingNavigation {
    var path: FileKitPath?
    var isPending = false
}
