//
//  UserDefaultsExtension.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation

private var _shared: UserDefaults?
private let suiteName = "group.app.scrapmd"

extension UserDefaults {
    static var shared: UserDefaults {
        if let shared = _shared {
            return shared
        }
        let shared = UserDefaults(suiteName: suiteName)!
        _shared = shared
        return shared
    }

    enum Key: String {
        case lastLocation = "ScrapmdLastLocation"
    }

    // MARK: -
    func removeObject(forKey defaultKey: Key) {
        removeObject(forKey: defaultKey.rawValue)
    }

    func set(_ value: Any?, forKey defaultKey: Key) {
        set(value, forKey: defaultKey.rawValue)
    }

    func string(forKey defaultKey: Key) -> String? {
        return string(forKey: defaultKey.rawValue)
    }

    func dictionary(forKey defaultKey: Key) -> [String: Any]? {
        return dictionary(forKey: defaultKey.rawValue)
    }

    var lastLocation: FileKitPath {
        get {
            if let raw = self.string(forKey: .lastLocation) {
                return FileKitPath(raw)
            }
            return FileKitPath.iCloudDocuments ?? FileKitPath.userDocuments
        }
        set(path) {
            self.set(path.rawValue, forKey: .lastLocation)
            self.synchronize()
        }
    }

}
