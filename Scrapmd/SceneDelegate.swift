//
//  SceneDelegate.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/04.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseAnalytics

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var pendingNavigation = PendingNavigation()
    var confirmingCreate = ConfirmingCreate()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = ContentView()
            .environmentObject(pendingNavigation)
            .environmentObject(confirmingCreate)
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        #if DEBUG
        if CommandLine.arguments.contains("UITestingDarkModeEnabled") {
            window?.overrideUserInterfaceStyle = .dark
        }
        #endif
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        FileManager.default.sync()
        NotificationCenter.default.post(Notification(name: .updateDirectory))
        guard let url = UIPasteboard.general.url else {
            UserDefaults.shared.lastConfirmedURL = nil
            confirmingCreate.isConfirming = false
            return
        }
        if UserDefaults.shared.lastConfirmedURL != url {
            UserDefaults.shared.lastConfirmedURL = url
            confirmingCreate.url = url
            confirmingCreate.isConfirming = true
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        pendingNavigation.path = FileKitPath(url.path)
        pendingNavigation.isPending = true
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
            else { return }
        var additionalParams = UserDefaults.shared.additionalParameters
        queryItems.forEach { item in
            if item.name.hasPrefix("scrapmd") {
                let value = item.value ?? "(empty)"
                additionalParams[item.name] = value
                Analytics.setUserProperty(value, forName: item.name)
            }
        }
        UserDefaults.shared.additionalParameters = additionalParams
    }
}
