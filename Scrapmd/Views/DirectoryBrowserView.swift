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
    @ObservedObject var directoryBrowser: DirectoryBrowser
    @State var isNewModalShown = false

    init(_ path: FileKitPath) {
        self.path = path
        self.directoryBrowser = DirectoryBrowser(path, onlyDirectory: false)
    }

    var body: some View {
        List {
            ForEach(directoryBrowser.items, id: \.self) { (item: DirectoryBrowser.Item) in
                ItemView(item)
            }
            .onDelete(perform: delete)
        }
        .listStyle(DefaultListStyle())
        .navigationBarTitle(path.fileName)
        .navigationBarItems(trailing: Button(action: {
            self.isNewModalShown = true
        }) {
            Image(systemName: "plus")
        }).sheet(isPresented: $isNewModalShown) {
            NewScrapView(isShown: self.$isNewModalShown)
        }
    }

    func delete(at offsets: IndexSet) {
        directoryBrowser.delete(at: offsets)
    }
}

struct DirectoryBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DirectoryBrowserView(FileKitPath("/Users/ngs/Documents/Scrapmd Demo"))
        }
    }
}
