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
    @Binding var isShown: Bool

    var body: some View {
        return NavigationView {
            VStack {
                NewScrapURLInputView(
                    urlString: $viewModel.urlString,
                    errorMessage: $viewModel.errorMessage,
                    isValid: $viewModel.isValid,
                    isFetching: $viewModel.isFetching,
                    isFetched: $viewModel.isFetched
                ) {
                    self.viewModel.fetch()
                }.navigationBarItems(
                    leading: Button(action: cancel, label: { Text("Cancel") })
                )
                NavigationLink(
                    destination: SaveActionView(
                        contentSaver: ContentSaver(result: viewModel.result),
                        cancelAction: cancel,
                        doneAction: cancel),
                    isActive: $viewModel.isFetched) {
                        Text("yo")
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    func cancel() {
        isShown = false
    }

    func save() {
        //        saverViewModel.download {
        //            self.isShown = false
        //        }
    }
}

struct NewScrapView_Previews: PreviewProvider {
    static var previews: some View {
        NewScrapView(isShown: .constant(true))
    }
}
