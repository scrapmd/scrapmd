//
//  ActionViewController.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import UIKit
import SwiftUI

class ActionViewController: UIViewController {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var hostingViewController: UIHostingController<SaveActionView>?

    func loadItem() {}

    func renderSaveView(result: APIClient.Result) {}

    func done() {}
}
