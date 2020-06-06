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

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ScrapReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapReaderView(path: FileKitPath("/Uss"))
    }
}
