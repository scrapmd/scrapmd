//
//  ActionViewController.swift
//  ActionExtension
//
//  Created by Atsushi Nagase on 2020/06/04.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import UIKit
import MobileCoreServices
import FileKit
import SwiftUI

class ActionViewController: UIViewController {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var hostingViewController: UIHostingController<NavigationView<SaveActionView>>?

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
            else {
                self.extensionContext!.cancelRequest(withError: NSError())
                return
        }
        provider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { (results, _) in
            guard
                let results = results as? [String: Any],
                let jsResults = results[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any],
                let html = jsResults["html"] as? String,
                let title = jsResults["title"] as? String,
                let urlString = jsResults["url"] as? String,
                let url = URL(string: urlString)
                else {
                    self.extensionContext!.cancelRequest(withError: NSError())
                    return
            }
            APIClient.fetch(url: url, title: title, prefetchedHTML: html) { (result, _, err) in
                if let result = result {
                    DispatchQueue.main.async {
                        self.renderSaveView(result: result)
                        self.activityIndicatorView.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.extensionContext!.cancelRequest(withError: err ?? NSError())
                    }
                }
            }
        }
    }

    func renderSaveView(result: APIClient.Result) {
        let saver = ContentSaver(result: result)
        let rootView = NavigationView {
            SaveActionView(
                contentSaver: saver,
                showCompletion: true,
                cancelAction: done,
                doneAction: { _ in },
                openAction: openSavedScrap
            )
        }
        let viewController = UIHostingController<NavigationView>(rootView: rootView)
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        viewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        hostingViewController = viewController
    }

    func done() {
        self.extensionContext!.completeRequest(
            returningItems: nil,
            completionHandler: nil
        )
    }

    func openSavedScrap(path: FileKitPath) {
        let url = path.fileURL(scheme: "scrapmd")
        _ = self.openURL(url)
        self.done()
    }

    //  https://stackoverflow.com/a/44499222
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }

}

func log(error: Error) {}
