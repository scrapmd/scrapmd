//
//  ScrapReaderView.ViewModel.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Combine
import Foundation

extension ScrapReaderView {
    @MainActor
@Observable
class ViewModel {
        var isLoading = true
        var markdown: String?
        var metadata: ScrapMetadata?

        let path: FileKitPath

        init(_ path: FileKitPath) {
            self.path = path
            self.load()
        }

        func load() {
            isLoading = true
            metadata = path.metadata
            markdown = try? path.markdownFile.read()
            isLoading = false
        }
    }
}
