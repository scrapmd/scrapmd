//
//  SaveActionView.swift
//  ActionExtension
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI
import UIKit

struct SaveActionView: View {
    typealias Action = () -> Void
    typealias FilePathAction = (_ path: FileKitPath) -> Void
    let cancelAction: Action
    let doneAction: FilePathAction
    let openAction: FilePathAction
    let showCompletion: Bool
    @ObservedObject var saverViewModel: SaveActionView.ViewModel
    @State var isDirectoryPickerActive = false
    @State var isCompleteShown = false
    @State var savedPath: FileKitPath?

    init(
        contentSaver: ContentSaver,
        showCompletion: Bool = false,
        cancelAction: @escaping Action,
        doneAction: @escaping FilePathAction,
        openAction: @escaping FilePathAction,
        path: FileKitPath? = nil
    ) {
        self.saverViewModel = SaveActionView.ViewModel(contentSaver: contentSaver)
        self.showCompletion = showCompletion
        self.cancelAction = cancelAction
        self.doneAction = doneAction
        self.openAction = openAction
        if let path = path {
            self.saverViewModel.saveLocation = path
        }
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
                    FileKitPath.documentRoot) { (path, _) in
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
            }
            .disabled(saverViewModel.isDownloading)
            .listStyle(GroupedListStyle())
            NavigationLink(
                destination: SaveCompleteView(savedPath: self.savedPath) { path in
                    if let path = path {
                        self.openAction(path)
                    } else {
                        self.cancelAction()
                    }
                },
                isActive: $isCompleteShown) {
                    Spacer()
            }.hidden()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("Save Scrap")
        .navigationBarItems(
            leading: Button(
                action: self.cancelAction,
                label: { Text("Cancel") }
            ).disabled(saverViewModel.isDownloading),
            trailing: Button(action: save, label: {
                if saverViewModel.isDownloading {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                } else {
                    Text("Save").fontWeight(.bold)
                }
            }).disabled(saverViewModel.isDownloading))
    }

    func save() {
        saverViewModel.download { dest in
            self.savedPath = dest
            self.doneAction(dest)
            if self.showCompletion {
                self.isCompleteShown = true
            }
        }
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
            doneAction: { _ in },
            openAction: { _ in })
            .preferredColorScheme(.dark)
    }
}
