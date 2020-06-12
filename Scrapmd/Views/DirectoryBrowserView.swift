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
    @EnvironmentObject var pendingNavigation: PendingNavigation
    @ObservedObject var directoryBrowser: DirectoryBrowser
    @State var isNewModalShown = false

    init(_ path: FileKitPath) {
        self.path = path
        self.directoryBrowser = DirectoryBrowser(path, onlyDirectory: false, sort: .created)
    }

    var body: some View {
        VStack {
            List {
                ForEach(directoryBrowser.sectionedIndices, id: \.0) { (section, indices) in
                    Section(header: Text(section == "" ? "Folder" : section)) {
                        ForEach(indices, id: \.self) { index in
                            ItemView(item: self.$directoryBrowser.items[index])
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(DefaultListStyle())
            NavigationLink(
                destination: ScrapReaderView(pendingNavigation.path ?? FileKitPath("")),
                isActive: $pendingNavigation.isPending) { Spacer().hidden() }
                .onAppear {}
        }
        .navigationBarTitle(path.fileName)
        .navigationBarItems(
            trailing: Button(action: {
                self.isNewModalShown = true
            }) {
                Image(systemName: "plus")
            }
        ).sheet(isPresented: $isNewModalShown) {
            NavigationView {
                NewScrapView(isShown: self.$isNewModalShown)
                    .environmentObject(self.pendingNavigation)
            }.navigationViewStyle(StackNavigationViewStyle())
        }.onAppear {
            FileManager.default.sync()
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
