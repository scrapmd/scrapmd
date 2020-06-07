//
//  CreateFolderView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/06.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI
import FileKit

struct CreateFolderView: View {
    let path: FileKitPath
    @Binding var isShown: Bool
    @State var name = ""
    @State var errorMessage: String?
    struct ErrorMessage: View {
        let message: String?

        @ViewBuilder
        var body: some View {
            if let message = message {
                Text(message)
            } else {
                Spacer()
            }
        }
    }

    var newPath: FileKitPath {
        path + name
    }
    var body: some View {
        NavigationView {
            List {
                VStack {
                    TextField("Folder Name", text: $name)
                    ErrorMessage(message: errorMessage)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Create New Folder")
            .navigationBarItems(
                leading: Button(action: cancel, label: { Text("Cancel") }),
                trailing: Button(action: create, label: { Text("Create").bold() }).disabled(self.name.isEmpty || self.newPath.exists)
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    func cancel() {
        isShown = false
    }

    func create() {
        do {
            try newPath.createDirectory()
            isShown = false
        } catch {
            self.errorMessage = "Failed to create folder"
        }

    }
}

struct CreateFolderView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFolderView(path: FileKitPath.userDocuments, isShown: .constant(true)).preferredColorScheme(.dark)
    }
}
