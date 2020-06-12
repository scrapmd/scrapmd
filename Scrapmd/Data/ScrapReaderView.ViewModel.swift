//
//  ScrapReaderView.ViewModel.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import Combine

extension ScrapReaderView {
    class ViewModel: ObservableObject {
        @Published var isLoading = true
        @Published var markdown: String?
        @Published var metadata: ScrapMetadata?

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
