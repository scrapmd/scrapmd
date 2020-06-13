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
    @ObservedObject var viewModel: ViewModel

    init(_ path: FileKitPath) {
        self.path = path
        self.viewModel = ViewModel(path)
    }

    struct ErrorView: View {
        var body: some View {
            Text("Could not load scrap")
        }
    }

    struct ContentView: View {
        @State private var isSharePresented = false
        @State private var showSource = false
        let metadata: ScrapMetadata
        let markdown: String
        let path: FileKitPath

        var body: some View {
            VStack {
                MarkdownView(markdown: markdown, path: path, showSource: $showSource)
                HStack {
                    Button(action: {
                        self.showSource.toggle()
                    }) {
                        Image(systemName: self.showSource ? "doc.richtext" : "chevron.left.slash.chevron.right")
                    }.padding().frame(width: 50)
                    Spacer()
                    Button(action: {
                        self.isSharePresented = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }.padding()
                    Spacer()
                    Button(action: {
                        UIApplication.shared.open(URL(string: self.metadata.url)!)
                    }) {
                        Image(systemName: "link")
                    }.padding()
                }.sheet(isPresented: $isSharePresented, content: {
                    ActivityViewController(activityItems: [self.path.fileURL(scheme: "file")])
                })
            }
        }
    }

    func buildBody() -> some View {
        if self.viewModel.isLoading {
            return AnyView(ActivityIndicator(isAnimating: .constant(true), style: .large))
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
        buildBody().navigationBarTitle("", displayMode: .inline)
    }
}

struct ScrapReaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrapReaderView(
                FileKitPath("/Users/ngs/Documents/Scrapmd Demo/demo2")
            ).navigationBarTitle("", displayMode: .inline)
        }
    }
}
