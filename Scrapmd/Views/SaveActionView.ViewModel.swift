//
//  SaveActionView.ViewModel.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/06.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import Combine
import FileKit

extension SaveActionView {
    class ViewModel: ObservableObject {
        var contentSaver: ContentSaver? = nil
        @Published var isDownloading = false
        @Published var saveLocation: Path = Path.iCloudDocuments ?? Path.userDocuments
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

        var savePath: Path {
            return saveLocation + "\(title)\(scrapDirectoryNameSuffix)"
        }

        func download(completionHandler: @escaping () -> Void) {
            isDownloading = true
            contentSaver?.download(to: savePath, progress: { (info, current, total) in
            }) { err in
                DispatchQueue.main.async {
                    self.isDownloading = false
                    if let err = err {
                        print(err)
                    } else {
                        completionHandler()
                    }
                }
            }
        }
    }
}
