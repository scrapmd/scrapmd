//
//  SaveActionView.swift
//  ActionExtension
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct SaveActionView: View {
    let contentSaver: ContentSaver
    let cancelAction: () -> Void
    let doneAction: () -> Void
    @State var scrapName: String = ""
    @State var saveLocation: String?
    @ObservedObject var viewModel = ViewModel()
    @State var isDirectoryPickerActive = false

    var body: some View {

        NavigationView {
            VStack {
                ProgressBar(value: $viewModel.downloadProgress).frame(height: 2)
                List {
                    Section(header: Text("Name")) {
                        TextField("Name", text: $viewModel.title)
                            .onAppear {
                                self.viewModel.title = self.contentSaver.result.title
                        }.disabled(self.viewModel.isDownloading)
                    }
                    Section(header: Text("Save Location")) {
                        NavigationLink(destination: DirectoryPickerView(
                            path: FileKitPath.iCloudDocuments ?? FileKitPath.userDocuments,
                            isPresenting: $isDirectoryPickerActive) { (path, _) in
                                if let path = path {
                                    self.viewModel.saveLocation = path
                                }
                        }, isActive: $isDirectoryPickerActive) {
                            Text(viewModel.saveLocation.fileName)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .foregroundColor(.accentColor)
                        }

                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Save Scrap")
            .navigationBarItems(
                leading: Button(action: cancelAction, label: {
                    Text("Cancel")
                }),
                trailing: Button(action: save, label: {
                    Text("Save").fontWeight(.bold)
                })
            )
        }
        .navigationViewStyle(DefaultNavigationViewStyle())
        .onAppear {
            self.viewModel.contentSaver = self.contentSaver
        }

    }

    func save() {
        viewModel.download(completionHandler: doneAction)
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
        return SaveActionView(contentSaver: ContentSaver(result: result), cancelAction: {}, doneAction: {}).preferredColorScheme(.dark)
    }
}
