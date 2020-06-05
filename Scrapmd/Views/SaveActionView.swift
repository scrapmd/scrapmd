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
    @State var saveLocation: String? = nil
    @ObservedObject var viewModel = ViewModel()

    var body: some View {

        NavigationView {
            List {
                Section(header: Text("Name")) {
                    TextField("Name", text: $viewModel.title)
                        .onAppear {
                            self.viewModel.title = self.contentSaver.result.title
                    }
                }
                Section(header: Text("Save Location")) {
                    Button(action: {

                    }) {
                        Text(viewModel.saveLocation.fileName)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Save Scrap")
            .navigationBarItems(
                leading: Button(action: cancelAction, label: {
                    Text("Cancel")
                }),
                trailing:  Button(action: save, label: {
                    Text("Save").fontWeight(.bold)
                })
            )
        }.navigationViewStyle(DefaultNavigationViewStyle())

    }

    func save() {

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
        return SaveActionView(contentSaver: ContentSaver(result: result), cancelAction: {}, doneAction:  {})
    }
}
