//
//  NewScrapView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct NewScrapView: View {
    @ObservedObject var viewModel = ViewModel()
    @ObservedObject var saverViewModel = ContentSaverViewModel()
    @Binding var isShown: Bool

    var body: some View {
        if let result = viewModel.result {
            if saverViewModel.contentSaver == nil {
                saverViewModel.contentSaver = ContentSaver(result: result)
            }
            return AnyView(NavigationView {
                SaveActionInputView(
                    downloadProgress: $saverViewModel.downloadProgress,
                    title: $saverViewModel.title,
                    isDownloading: $saverViewModel.isDownloading,
                    saveLocation: $saverViewModel.saveLocation)
                    .navigationBarTitle("Save Scrap")
                    .navigationBarItems(
                        leading: Button(action: cancel, label: {
                            Text("Cancel")
                        }),
                        trailing: Button(action: save, label: {
                            Text("Save").fontWeight(.bold)
                        })
                )
            }.navigationViewStyle(StackNavigationViewStyle()))
        }
        return AnyView(NavigationView {
            NewScrapURLInputView(
                urlString: $viewModel.urlString,
                errorMessage: $viewModel.errorMessage,
                isValid: $viewModel.isValid,
                isFetching: $viewModel.isFetching
            ) {
                self.viewModel.fetch()
            }.navigationBarItems(
                leading: Button(action: cancel, label: { Text("Cancel") })
            )
        }.navigationViewStyle(StackNavigationViewStyle()))
    }

    func cancel() {
        isShown = false
    }

    func save() {
        saverViewModel.download {
            self.isShown = false
        }
    }
}

struct NewScrapView_Previews: PreviewProvider {
    static var previews: some View {
        NewScrapView(isShown: .constant(true))
    }
}
