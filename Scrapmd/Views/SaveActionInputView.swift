//
//  SaveActionInputView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct SaveActionInputView: View {
    @Binding var downloadProgress: Float
    @Binding var title: String
    @Binding var isDownloading: Bool
    @Binding var saveLocation: FileKitPath
    @State var isDirectoryPickerActive = false

    var body: some View {
        VStack {
            ProgressBar(value: $downloadProgress).frame(height: 2)
            List {
                Section(header: Text("Name")) {
                    TextField("Name", text: $title).disabled(isDownloading)
                }
                Section(header: Text("Save Location")) {
                    NavigationLink(destination: DirectoryPickerView(
                        FileKitPath.iCloudDocuments ?? FileKitPath.userDocuments) { (path, _) in
                            if let path = path {
                                self.saveLocation = path
                            }
                            self.isDirectoryPickerActive = false
                    }, isActive: $isDirectoryPickerActive) {
                        Text(saveLocation.fileName)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct SaveActionInputView_Previews: PreviewProvider {
    static var previews: some View {
        SaveActionInputView(
            downloadProgress: .constant(0.2),
            title: .constant("hoge"),
            isDownloading: .constant(false),
            saveLocation: .constant(FileKitPath.userMusic)
        )
    }
}
