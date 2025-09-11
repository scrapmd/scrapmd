//
//  ContentView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/04.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

@MainActor
struct ContentView: View {
    @EnvironmentObject var pendingNavigation: PendingNavigation

    var body: some View {
        NavigationSplitView {
            DirectoryBrowserView(FileKitPath.documentRoot)
        } detail: {
            DetailPlaceholderView()
        }
    }
}

#Preview {
    ContentView()
}
