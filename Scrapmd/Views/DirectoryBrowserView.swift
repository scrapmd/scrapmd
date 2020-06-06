//
//  DirectoryBrowserView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/06.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct DirectoryBrowserView: View {


    let path: FileKitPath
    @ObservedObject var directoryBrowser = DirectoryBrowser()
    var body: some View {
        List {
            ForEach(directoryBrowser.items, id: \.self) { (item: FileKitPath) in
                ItemView(path: item)
            }
        }
        .listStyle(DefaultListStyle())
        .navigationBarTitle(path.fileName)
        .navigationBarItems(trailing: EditButton())
        .onAppear {
            self.directoryBrowser.path = self.path
            self.directoryBrowser.onlyDirectory = false
        }
    }
}

struct DirectoryBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DirectoryBrowserView(path: FileKitPath("/Users/ngs/Documents/Scrapmd Demo"))
        }
    }
}
