//
//  SaveActionView.swift
//  ActionExtension
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct SaveActionView: View {
    let cancelAction: () -> Void
    let doneAction: () -> Void
    @ObservedObject var saverViewModel: SaveActionView.ViewModel
    @State var isDirectoryPickerActive = false

    init(contentSaver: ContentSaver, cancelAction: @escaping () -> Void, doneAction: @escaping () -> Void) {
        self.saverViewModel = SaveActionView.ViewModel(contentSaver: contentSaver)
        self.cancelAction = cancelAction
        self.doneAction = doneAction
    }

    var body: some View {
        VStack {
            ProgressBar(value: $saverViewModel.downloadProgress).frame(height: 2)
            List {
                Section(header: Text("Name")) {
                    TextField("Name", text: $saverViewModel.title)
                }
                Section(header: Text("Save Location")) {
                    NavigationLink(destination: DirectoryPickerView(
                    FileKitPath.iCloudDocuments ?? FileKitPath.userDocuments) { (path, _) in
                        if let path = path {
                            self.saverViewModel.saveLocation = path
                        }
                        self.isDirectoryPickerActive = false
                    }, isActive: $isDirectoryPickerActive) {
                        Text(saverViewModel.saveLocation.fileName)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .foregroundColor(.accentColor)
                    }
                }
            }.disabled(saverViewModel.isDownloading)
        }
        .listStyle(GroupedListStyle())
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("Save Scrap")
        .navigationBarItems(
            leading: Button(action: cancelAction, label: {
                Text("Cancel")
            }).disabled(saverViewModel.isDownloading),
            trailing: Button(action: save, label: {
                if saverViewModel.isDownloading {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                } else {
                    Text("Save").fontWeight(.bold)
                }
            }).disabled(saverViewModel.isDownloading))
    }

    func save() {
        saverViewModel.download(completionHandler: doneAction)
    }
}

struct SavePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        let result = APIClient.Result(
            title: ".//?-\\a.寿限無　寿限無　五劫のすりきれ 海砂利水魚の水行末　雲来末　風来末 食う寝るところに住むところ",
            markdown: "",
            url: "http://basin.example.org/?attack=bomb&amusement=berry#boat",
            images: [:]
        )
        return SaveActionView(
            contentSaver: ContentSaver(result: result),
            cancelAction: {},
            doneAction: {})
            .preferredColorScheme(.dark)
    }
}
