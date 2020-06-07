//
//  ScrapReaderView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI
import Ink

struct ScrapReaderView: View {
    let path: FileKitPath
    @ObservedObject var viewModel = ViewModel()

    struct ErrorView: View {
        var body: some View {
            Text("Could not load scrap")
        }
    }

    struct ContentView: View {
        let metadata: ScrapMetadata
        let markdown: String
        let path: FileKitPath
        var body: some View {
            MarkdownView(markdown: markdown, path: path)
        }
    }

    func buildBody() -> some View {
        if self.viewModel.isLoading {
            return AnyView(Spacer())
        } else if
            let metadata = self.viewModel.metadata,
            let markdown = self.viewModel.markdown
        {
            return AnyView(ContentView(
                metadata: metadata,
                markdown: markdown,
                path: path
            ))
        }
        return AnyView(ErrorView())
    }

    @ViewBuilder
    var body: some View {
        buildBody().onAppear {
            self.viewModel.path = self.path
            self.viewModel.load()
        }.navigationBarTitle("", displayMode: .inline)
    }
}

struct ScrapReaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrapReaderView(path: FileKitPath("/Users/ngs/Documents/Scrapmd Demo/demo2")).navigationBarTitle("", displayMode: .inline)
        }
    }
}
