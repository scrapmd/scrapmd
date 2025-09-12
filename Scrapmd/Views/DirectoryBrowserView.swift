//
//  DirectoryBrowserView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/06.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

@MainActor
struct DirectoryBrowserView: View {
    enum Sheet {
        case about, new
    }
    let path: FileKitPath
    @Environment(PendingNavigation.self) var pendingNavigation
    @Environment(ConfirmingCreate.self) var confirmingCreate
    @Bindable var directoryBrowser: DirectoryBrowser
    @State var isModalShown = false
    @State var currentSheet: Sheet = .about

    init(_ path: FileKitPath) {
        self.path = path
        self.directoryBrowser = DirectoryBrowser(path, onlyDirectory: false, sort: .created)
    }

    var body: some View {
        let vstack = VStack {
            List {
                ForEach(directoryBrowser.sectionedIndices, id: \.0) { section, indices in
                    Section(header: Text(section == "" ? "Folder" : section)) {
                        ForEach(indices, id: \.self) { index in
                            ItemView(item: self.$directoryBrowser.items[index])
                        }
                        .onDelete {
                            self.delete(at: IndexSet($0.map { indices[$0] }))
                        }
                    }
                }
            }
            .listStyle(DefaultListStyle())
            NavigationLink(
                destination: ScrapReaderView(pendingNavigation.path ?? FileKitPath("")),
                isActive: .constant(pendingNavigation.isPending)) { EmptyView() }
                .onAppear {}
        }
        .navigationBarTitle(path.isRoot ? NSLocalizedString("Home", comment: "Home") : path.fileName)
        .alert(isPresented: .constant(confirmingCreate.isConfirming)) {
            Alert(
                title: Text("Create New Scrap"),
                message: Text("pasteboard.confirmMessage \(self.confirmingCreate.url?.absoluteString ?? "")"),
                primaryButton: .default(Text("Yes")) {
                    self.showSheet(.new)
                },
                secondaryButton: .cancel {
                    self.confirmingCreate.url = nil
                })
        }
        .sheet(isPresented: $isModalShown) {
            NavigationView { self.buildSheetContent() }
                .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear {
            FileManager.default.sync()
        }.accessibility(identifier: "DirectoryBrowser")
        let newButton = Button(action: {
            self.showSheet(.new)
        }) {
            Image(systemName: "plus")
        }
        if path.isRoot {
            return AnyView(vstack.navigationBarItems(
                leading: Button(action: {
                    self.showSheet(.about)
                }) {
                    Image(systemName: "info.circle.fill")
                },
                trailing: newButton
            ))
        }
        return AnyView(vstack.navigationBarItems(
            trailing: newButton
        ))
    }

    func showSheet(_ sheet: Sheet) {
        currentSheet = sheet
        isModalShown = true
    }

    @ViewBuilder
    func buildSheetContent() -> some View {
        if currentSheet == .new {
            NewScrapView(path: path, isShown: $isModalShown)
                .environment(pendingNavigation)
                .environment(confirmingCreate)
        } else if currentSheet == .about {
            AboutView(isShown: $isModalShown)
        } else {
            EmptyView()
        }
    }

    func delete(at offsets: IndexSet) {
        directoryBrowser.delete(at: offsets)
    }
}

#Preview {
    NavigationView {
        DirectoryBrowserView(FileKitPath("/Users/ngs/Documents/Scrapmd Demo"))
    }
}
