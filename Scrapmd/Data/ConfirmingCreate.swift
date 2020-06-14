//
//  ConfirmingCreate.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/14.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import Combine

class ConfirmingCreate: ObservableObject {
    @Published var url: URL?
    @Published var isConfirming = false
}
