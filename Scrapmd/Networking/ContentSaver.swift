//
//  ContentSaver.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 Atsushi Nagase. All rights reserved.
//

import Foundation
import FileKit

struct ContentSaver {
    let result: APIClient.Result

    struct ProgressInfo {
        let url: URL
        let destination: ImageFile

        func queue(completionHandler: @escaping (ProgressInfo, Error?) -> Void) -> DownloadQueue {
            let task = URLSession.shared.downloadTask(with: url) { (url, _, err) in
                do {
                    let img = ImageFile(path: Path(url: url!)!)
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

    func download(to: Path, progress: @escaping ProgressHandler, completionHandler: @escaping CompletionHandler) {

        do {
            try to.createDirectory(withIntermediateDirectories: true)
            try result.markdown |> TextFile(path: to + "content.md")
        } catch {
            completionHandler(error)
            return
        }
        var queues: [DownloadQueue] = []
        var total = 0
        for (sum, url) in result.images {
            let queue = ProgressInfo(url: URL(string: url)!, destination: ImageFile(path: to + sum)).queue { (info, err) in
                if let err = err {
                    completionHandler(err)
                    return
                }
                if queues.isEmpty {
                    completionHandler(nil)
                    return
                }
                let q = queues.removeFirst()
                progress(q.info, total - queues.count - 1, total)
                q.resume()
            }
            queues.append(queue)
        }
        total = queues.count
        let q = queues.removeFirst()
        progress(q.info, 0, total)
        q.resume()
    }
}
