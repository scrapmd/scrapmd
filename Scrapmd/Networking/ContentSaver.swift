//
//  ContentSaver.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import FileKit

struct ContentSaver {
    let result: APIClient.Result

    struct ProgressInfo {
        let url: URL
        let destination: ImageFile

        func queue(completionHandler: @escaping (ProgressInfo, Error?) -> Void) -> DownloadQueue {
            let task = URLSession.shared.downloadTask(with: url) { (localURL, _, _) in
                guard let localURL = localURL else {
                    completionHandler(self, nil)
                    return
                }
                do {
                    let img = ImageFile(path: Path(url: localURL)!)
                    if self.destination.exists {
                        try self.destination.delete()
                    }
                    try self.destination.path.parent.createDirectory(withIntermediateDirectories: true)
                    try img.move(to: self.destination.path)
                    completionHandler(self, nil)
                } catch {
                    completionHandler(self, error)
                }
            }
            return DownloadQueue(info: self, task: task)
        }
    }

    struct DownloadQueue {
        let info: ProgressInfo
        let task: URLSessionDownloadTask

        func resume() {
            task.resume()
        }
    }

    typealias ProgressHandler = (ProgressInfo, Int, Int) -> Void
    typealias CompletionHandler = (Error?) -> Void

    func finalize(_ dest: Path) {
        if !dest.thumbnailFile.exists {
            let found = (dest + "img").children().sorted {
                ($0.fileSize ?? 0) > ($1.fileSize ?? 0)
            }.first
            try? found?.copyFile(to: dest.thumbnailFile.path)
        }
    }

    // swiftlint:disable:next identifier_name function_body_length
    func download(to: Path, name: String, progress: @escaping ProgressHandler,
                  completionHandler: @escaping CompletionHandler) {
        var dest = to + "\(name)\(scrapDirectoryNameSuffix)"
        var num = 0
        while dest.exists {
            num += 1
            let suffix = " \(num)"
            // swiftlint:disable:next line_length
            dest = dest.parent + "\(name.prefix(scrapDirectoryNameMaxLength - suffix.count))\(suffix)\(scrapDirectoryNameSuffix)"
        }
        do {
            try dest.createDirectory(withIntermediateDirectories: true)
            try result.markdown |> TextFile(path: dest + markdownFilename)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .default
            let data = try encoder.encode(result.createMetadata())
            try String(data: data, encoding: .utf8)! |> TextFile(path: dest + metadataFilename)
        } catch {
            completionHandler(error)
            return
        }
        var queues: [DownloadQueue] = []
        var total = 0
        var images = result.images
        if let leadImageURL = result.leadImageURL {
            images[thumbnailPath] = leadImageURL
        }
        for (sum, url) in images {
            let queue = ProgressInfo(
                url: URL(string: url)!,
                destination: ImageFile(path: dest + sum)
            ).queue { (info, err) in
                if let err = err {
                    completionHandler(err)
                    return
                }
                if queues.isEmpty {
                    self.finalize(dest)
                    completionHandler(nil)
                    return
                }
                let firstQueue = queues.removeFirst()
                progress(firstQueue.info, total - queues.count - 1, total)
                firstQueue.resume()
            }
            queues.append(queue)
        }
        if queues.isEmpty {
            completionHandler(nil)
            return
        }
        total = queues.count
        let firstQueue = queues.removeFirst()
        progress(firstQueue.info, 0, total)
        firstQueue.resume()
    }
}
