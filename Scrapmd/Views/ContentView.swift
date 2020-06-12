//
//  ContentView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/04.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pendingNavigation: PendingNavigation

    var body: some View {
        NavigationView {
            DirectoryBrowserView(FileKitPath.iCloudDocuments ?? FileKitPath.userDocuments)
            DetailPlaceholderView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
