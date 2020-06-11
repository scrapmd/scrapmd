//
//  DirectoryBrowserView.ItemView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

extension DirectoryBrowserView {
    struct ScrapItemView: View {
        @Binding var item: DirectoryBrowser.Item

        var body: some View {
            NavigationLink(destination: ScrapReaderView(item.path)) {
                HStack {
                    Image(uiImage: item.thumbnail ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                        .clipped()
                    VStack(alignment: .leading) {
                        Text(item.metadata!.title)
                        Text("\(item.metadata!.createdAt, formatter: displayDateFormatter)")
                            .font(.caption)
                            .opacity(0.5)
                            .padding(.top, 5.0)
                    }
                }
            }.isDetailLink(true)
        }
    }

    struct FolderItemView: View {
        @Binding var item: DirectoryBrowser.Item

        var body: some View {
            NavigationLink(destination: DirectoryBrowserView(item.path)) {
                HStack {
                    Image(systemName: "folder")
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                    VStack(alignment: .leading) {
                        Text(item.fileName)
                        HStack {
                            if item.scrapsCount > 0 {
                                Text("\(item.scrapsCount).scraps")
                                    .font(.caption)
                                    .opacity(0.5)
                            }
                            if item.foldersCount > 0 {
                                Text("\(item.foldersCount).folders")
                                    .font(.caption)
                                    .opacity(0.5)
                            }
                        }
                    }
                }
            }.isDetailLink(false)
        }
    }

    struct ItemView: View {
        @Binding var item: DirectoryBrowser.Item

        var body: some View {
            if item.metadata != nil {
                return AnyView(DirectoryBrowserView.ScrapItemView(item: $item))
            }
            return AnyView(DirectoryBrowserView.FolderItemView(item: $item))
        }
    }
}

struct DirectoryBrowserViewItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DirectoryBrowserView.FolderItemView(item:
                .constant(DirectoryBrowser.Item(FileKitPath("/Users/ngs/Documents"))))
            DirectoryBrowserView.ScrapItemView(item:
                .constant(DirectoryBrowser.Item(FileKitPath("/Users/ngs/Documents"))))
        }
    }
}
