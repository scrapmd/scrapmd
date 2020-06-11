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
        let path: FileKitPath
        @Binding var metadata: ScrapMetadata?
        let thumbnail: UIImage?

        var body: some View {
            NavigationLink(destination: ScrapReaderView(path)) {
                HStack {
                    Image(uiImage: thumbnail ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                        .clipped()
                    VStack(alignment: .leading) {
                        Text(metadata!.title)
                        Text("\(metadata!.createdAt, formatter: displayDateFormatter)")
                            .font(.caption)
                            .opacity(0.5)
                            .padding(.top, 5.0)
                    }
                }
            }.isDetailLink(true)
        }
    }

    struct FolderItemView: View {
        let path: FileKitPath

        var body: some View {
            NavigationLink(destination: DirectoryBrowserView(path)) {
                HStack {
                    Image(systemName: "folder")
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                    VStack(alignment: .leading) {
                        Text(path.fileName)
                        HStack {
                            if path.scrapsCount > 0 {
                                Text("\(path.scrapsCount).scraps")
                                    .font(.caption)
                                    .opacity(0.5)
                            }
                            if path.foldersCount > 0 {
                                Text("\(path.foldersCount).folders")
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
        @ObservedObject var item: DirectoryBrowser.Item

        init(_ item: DirectoryBrowser.Item) {
            self.item = item
        }

        var body: some View {
            let path = item.path
            if item.metadata != nil {
                return AnyView(DirectoryBrowserView.ScrapItemView(
                    path: path,
                    metadata: $item.metadata,
                    thumbnail: item.thumbnail
                ))
            }
            return AnyView(DirectoryBrowserView.FolderItemView(path: path))
        }
    }
}

struct DirectoryBrowserViewItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DirectoryBrowserView.FolderItemView(path: FileKitPath("/Users/ngs/Documents"))
            DirectoryBrowserView.ScrapItemView(
                path: FileKitPath("."),
                metadata: .constant(ScrapMetadata(
                    title: "寿限無　寿限無　五劫のすりきれ 海砂利水魚の水行末　雲来末　風来末 食う寝るところに住むところ",
                    url: "https://ja.ngs.io/",
                    createdAt: Date(timeIntervalSince1970: 1591473224),
                    appVersion: "1.0.0")),
                thumbnail: #imageLiteral(resourceName: "thumbnail"))
        }
    }
}
