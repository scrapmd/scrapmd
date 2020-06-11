//
//  DirectoryPickerView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/06.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct DirectoryPickerView: View {
    typealias ChooseHandler = (_ path: FileKitPath?, _ sender: DirectoryPickerView) -> Void
    let path: FileKitPath
    @ObservedObject var directoryBrowser: DirectoryBrowser
    @State var isNewFolderModalShown = false
    let chooseHandler: ChooseHandler
    let chosenPath: FileKitPath?

    init(_ path: FileKitPath, chosenPath: FileKitPath? = nil, chooseHandler: @escaping ChooseHandler) {
        self.directoryBrowser = DirectoryBrowser(path, onlyDirectory: true, sort: .name)
        self.path = path
        self.chooseHandler = chooseHandler
        self.chosenPath = chosenPath
    }

    var body: some View {
        return VStack {
            List {
                ForEach(directoryBrowser.items, id: \.self) { (item: DirectoryBrowser.Item) in
                    NavigationLink(
                        destination: DirectoryPickerView(item.path) { (path, sender) in
                            self.choose(path, sender)
                        },
                        label: {
                            HStack {
                                Text(item.path.fileName)
                                if self.chosenPath == item.path {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                    }
                    ).isDetailLink(false)
                }
            }
            .listStyle(DefaultListStyle())
            HStack {
                Button(action: { self.isNewFolderModalShown = true }) {
                    Image(systemName: "folder.badge.plus")
                }
                .padding(.all)
                Spacer()
                Button(action: { self.choose(self.path, self) }) {
                    Text("Choose")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.all)
            }
        }
        .navigationBarTitle(path.fileName)
        .sheet(isPresented: $isNewFolderModalShown) {
            CreateFolderView(path: self.path, isShown: self.$isNewFolderModalShown)
        }
    }

    func choose(_ path: FileKitPath?, _ sender: DirectoryPickerView) {
        chooseHandler(path, self)
    }
}

struct DirectoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DirectoryPickerView(
            FileKitPath.userDocuments) { (_, _) in }
        }
    }
}
