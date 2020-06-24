//
//  AppDelegate.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/04.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import UIKit
#if !targetEnvironment(macCatalyst)
import FirebaseCore
import FirebaseCrashlytics
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        #if !targetEnvironment(macCatalyst)
        FirebaseApp.configure()
        #endif
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

func log(error: Error) {
    print(error)

    #if !targetEnvironment(macCatalyst)
    Crashlytics.crashlytics().record(error: error)
    #endif
}
