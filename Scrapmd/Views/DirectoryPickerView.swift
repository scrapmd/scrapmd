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
    @ObservedObject var directoryBrowser = DirectoryBrowser(onlyDirectory: true)
    @Binding var isPresenting: Bool
    @State var isNewFolderModalShown = false
    let chooseHandler: ChooseHandler

    var body: some View {
        return VStack {
            List {
                ForEach(directoryBrowser.items, id: \.self) { (item: FileKitPath) in
                    NavigationLink(
                        destination: DirectoryPickerView(path: item, isPresenting: self.$isPresenting) { (path, sender) in
                            self.choose(path, sender)
                        },
                        label: { Text(item.fileName) }
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
        }.onAppear {
            self.directoryBrowser.path = self.path
        }
    }

    func choose(_ path: FileKitPath?, _ sender: DirectoryPickerView) {
        chooseHandler(path, self)
        isPresenting = false
    }
}

struct DirectoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DirectoryPickerView(
                path: FileKitPath.userDocuments,
                isPresenting: .constant(false)) { (_, _) in }
        }
    }
}
