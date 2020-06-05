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
import SwiftUI

 class ActionViewController: UIViewController {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var hostingViewController: UIHostingController<SaveActionView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    }

    func loadItem() {
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
                    DispatchQueue.main.async {
                        self.renderSaveView(result: result)
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }

    func renderSaveView(result: APIClient.Result) {
        let saver = ContentSaver(result: result)
        let rootView = SaveActionView(contentSaver: saver)
        let vc = UIHostingController<SaveActionView>(rootView: rootView)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        hostingViewController = vc
    }

//    @IBAction func done() {
//        // Return any edited content to the host app.
//        // This template doesn't do anything, so we just echo the passed in items.
//        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
//    }

}
