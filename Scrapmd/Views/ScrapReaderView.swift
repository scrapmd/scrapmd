//
//  ScrapReaderView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct ScrapReaderView: View {
    let path: FileKitPath
    @State var isLoading = true
    @State var metadata: ScrapMetadata?
    @State var markdown: String?

    struct ErrorView: View {
        var body: some View {
            Text("Could not load scrap")
        }
    }

    struct ContentView: View {
        let metadata: ScrapMetadata
        let content: String
        var body: some View {
            VStack {
                Text(metadata.title)
                Spacer()
            }
        }
    }

    func buildBody() -> some View {
        if isLoading {
            return AnyView(Spacer().onAppear {
                self.metadata = self.path.metadata
                self.isLoading = false
                self.markdown = try? self.path.markdownFile.read()
            })
        } else if
            let metadata = metadata,
            let markdown = markdown
        {
            return AnyView(ContentView(metadata: metadata, content: markdown))
        }
        return AnyView(ErrorView())
    }

    @ViewBuilder
    var body: some View {
        buildBody()
    }
}

struct ScrapReaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ScrapReaderView(path: FileKitPath("/Users/ngs/Documents/Scrapmd Demo/demo2"))
        }
    }
}
