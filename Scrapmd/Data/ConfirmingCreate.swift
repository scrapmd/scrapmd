//
//  ConfirmingCreate.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/14.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Combine
import Foundation

@MainActor
@Observable
class ConfirmingCreate {
    var url: URL?
    var isConfirming = false
}
