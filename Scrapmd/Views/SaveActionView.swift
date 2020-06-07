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
    @ObservedObject var saverViewModel = ContentSaverViewModel()

    var body: some View {
        NavigationView {
            SaveActionInputView(
                downloadProgress: $saverViewModel.downloadProgress,
                title: $saverViewModel.title,
                isDownloading: $saverViewModel.isDownloading,
                saveLocation: $saverViewModel.saveLocation)
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle("Save Scrap")
                .navigationBarItems(
                    leading: Button(action: cancelAction, label: {
                        Text("Cancel")
                    }),
                    trailing: Button(action: save, label: {
                        Text("Save").fontWeight(.bold)
                    }))
                .onAppear { self.saverViewModel.contentSaver = self.contentSaver }
        }
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
        return SaveActionView(contentSaver: ContentSaver(result: result), cancelAction: {}, doneAction: {}).preferredColorScheme(.dark)
    }
}
