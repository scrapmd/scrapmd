//
//  CoreDataExtension.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension NSPersistentContainer {
    static var shared: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
}
