//
//  ActionViewController.swift
//  ActionExtension
//
//  Created by Atsushi Nagase on 2020/06/04.
//  Copyright © 2020 Atsushi Nagase. All rights reserved.
//

import UIKit
import MobileCoreServices
import FileKit

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let inputItems = extensionContext?.inputItems as? [NSExtensionItem],
            let provider = inputItems
                .flatMap({ $0.attachments ?? [] })
                .first(where: { $0.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) })
            else { return }
        provider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { (results, _) in
            guard
                let results = results as? [String: Any],
                let jsResults = results[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any],
                let html = jsResults["html"] as? String,
                let urlString = jsResults["url"] as? String,
                let url = URL(string: urlString)
                else { return }
            APIClient.fetch(url: url, prefetchedHTML: html) { (result, _, err) in
                if let result = result {
                    let saver = ContentSaver(result: result)
                    let root = Path.iCloudDocuments ?? Path.userDocuments
                    
                    saver.download(to: root + "test", progress: { (info, current, total) in
                        print("\(info);\(current);\(total)")
                    }) {err in
                        print(err ?? "ok")
                    }
                    return
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
