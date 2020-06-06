//
//  BundleAppInfoExtension.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/06.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//
import Foundation
import UIKit

extension Bundle {
    var appVersion: String {
        guard
            let infoDictionary = infoDictionary,
            let value = infoDictionary["CFBundleShortVersionString"] as? String
            else { fatalError("Could not fetch value of CFBundleShortVersionString") }
        return value
    }

    var buildNumber: String {
        guard
            let infoDictionary = infoDictionary,
            let value = infoDictionary["CFBundleVersion"] as? String
            else { fatalError("Could not fetch value of CFBundleVersion") }
        return value
    }

    var copyright: String {
        guard
            let infoDictionary = infoDictionary,
            let value = infoDictionary["NSHumanReadableCopyright"] as? String
            else { fatalError("Could not fetch value of NSHumanReadableCopyright") }
        return value
    }

    var deviceModel: String {
        #if targetEnvironment(macCatalyst)
        return "Mac"
        #else
        return UIDevice.current.model
        #endif
    }

    var deviceSummary: String {
        return """
----
Device: \(deviceModel) / \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)
Version: \(appVersion) (\(buildNumber))
"""
.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var submitIssueURL: URL {
        return URL(string: "https://github.com/ngs/scrapmd/issues/new?body=\(deviceSummary)")!
    }

    var contactURL: URL {
        let device = deviceModel.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let version = "\(appVersion) (\(buildNumber)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return URL(string: "https://scrapmd.app/contact/?device=\(device)&version=\(version))")!
    }
}
