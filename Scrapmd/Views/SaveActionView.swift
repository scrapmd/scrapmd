//
//  SaveActionView.swift
//  ActionExtension
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 Atsushi Nagase. All rights reserved.
//

import SwiftUI

struct SaveActionView: View {
    let contentSaver: ContentSaver
    @State var scrapName: String = "" {
        didSet {
            if scrapName.count > scrapDirectoryNameMaxLength {
                scrapName = oldValue
            }
        }
    }
    @State var saveLocation: String? = nil

    var body: some View {

        NavigationView {
            List {
                Section(header: Text("Name")) {
                    TextField("Name", text: $scrapName).onAppear {
                        self.scrapName = String(self.contentSaver.result.title.prefix(scrapDirectoryNameMaxLength))
                        }
                }
                Section(header: Text("Save Location")) {
                    Button(action: {

                    }) {
                        Text("dada")
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Save Scrap")
            .navigationBarItems(
                leading: Button(action: {}, label: {
                    Text("Cancel")
                }),
                trailing:  Button(action: {}, label: {
                    Text("Save")
                })
            )
        }.navigationViewStyle(DefaultNavigationViewStyle())

    }
}

struct SavePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        let result = APIClient.Result(
            title: "寿限無　寿限無　五劫のすりきれ 海砂利水魚の水行末　雲来末　風来末 食う寝るところに住むところ",
            markdown: "",
            url: "http://basin.example.org/?attack=bomb&amusement=berry#boat",
            images: [:]
        )
        return SaveActionView(contentSaver: ContentSaver(result: result))
    }
}
