//
//  ContentSaverViewModel.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import Combine
import FileKit

class ContentSaverViewModel: ObservableObject {
    var contentSaver: ContentSaver? {
        didSet {
            if let title = contentSaver?.result.title {
                self.title = title
            }
        }
    }

    @Published var isDownloading = false
    @Published var saveLocation: Path = Path.iCloudDocuments ?? Path.userDocuments
    @Published var downloadProgress: Float = 0

    @Published var title: String = "" {
        didSet {
            var invalidCharacters = CharacterSet(charactersIn: ":/")
            invalidCharacters.formUnion(.newlines)
            invalidCharacters.formUnion(.illegalCharacters)
            invalidCharacters.formUnion(.controlCharacters)
            var newValue = title.components(separatedBy: invalidCharacters).joined(separator: "")
            if newValue.count > scrapDirectoryNameMaxLength {
                newValue = String(newValue.prefix(scrapDirectoryNameMaxLength))
            }
            if newValue.first == "." {
                newValue.removeFirst()
            }
            if newValue != title {
                title = newValue
            }
        }
    }

    func download(completionHandler: @escaping () -> Void) {
        isDownloading = true
        downloadProgress = 0
        contentSaver?.download(to: saveLocation, name: title, progress: { (_, current, total) in
            DispatchQueue.main.async {
                self.downloadProgress = Float(current) / Float(total)
            }
        }, completionHandler: { err in
            DispatchQueue.main.async {
                self.downloadProgress = 1.0
                if let err = err {
                    print(err)
                    self.isDownloading = false
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        completionHandler()
                        self.isDownloading = false
                    }
                }
            }
        })
    }
}
