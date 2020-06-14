//
//  NewScrapView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct NewScrapView: View {
    @EnvironmentObject var pendingNavigation: PendingNavigation
    @EnvironmentObject var confirmingCreate: ConfirmingCreate
    @ObservedObject(initialValue: ViewModel()) var viewModel: ViewModel
    let path: FileKitPath
    @Binding var isShown: Bool

    var body: some View {
        return
            VStack {
                HStack {
                    Text("Enter URL to fetch")
                        .font(.caption)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Spacer()
                }
                TextField("URL", text: $viewModel.urlString)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.all)
                    .background(Color(UIColor.secondarySystemFill))
                    .cornerRadius(11)
                    .disabled(viewModel.isFetching)
                    .onAppear {
                        if let url = self.confirmingCreate.url,
                            url.absoluteString != self.viewModel.urlString {
                            self.viewModel.urlString = url.absoluteString
                            self.viewModel.fetch()
                        }
                }
                HStack {
                    Text(viewModel.errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                }
                Spacer().frame(height: 10)
                Button(action: { self.viewModel.fetch() }) {
                    (self.viewModel.isFetching ?
                        AnyView(ActivityIndicator(
                            isAnimating: .constant(true), style: .medium)) :
                        AnyView(Text("Fetch Web Page")))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.all)
                        .background(Color.accentColor)
                        .cornerRadius(11)
                }
                .multilineTextAlignment(.center)
                .disabled(!self.viewModel.isValid || self.viewModel.isFetching)
                Spacer()
                NavigationLink(
                    destination: SaveActionView(
                        contentSaver: ContentSaver(result: viewModel.result),
                        cancelAction: cancel,
                        doneAction: { path in
                            self.pendingNavigation.path = path
                            self.pendingNavigation.isPending = true
                            self.cancel()
                    },
                        openAction: { _ in },
                        path: path
                    ),
                    isActive: $viewModel.isFetched) {
                        EmptyView()
                }
            }
            .padding(.all)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitle("Create New Scrap")
            .navigationBarItems(
                leading: Button(action: cancel, label: { Text("Cancel") })
        )
    }

    func cancel() {
        confirmingCreate.url = nil
        isShown = false
    }
}

struct NewScrapView_Previews: PreviewProvider {
    static var previews: some View {
        NewScrapView(path: .documentRoot, isShown: .constant(true))
    }
}
