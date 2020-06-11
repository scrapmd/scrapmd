//
//  ProgressBar.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/06.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float

    var body: some View {
        GeometryReader { geometry in

            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0)
                Rectangle().frame(
                    width: min(CGFloat(self.value)*geometry.size.width,
                               geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.accentColor)
                    .animation(.linear)
            }

        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProgressBar(value: .constant(0.2)).frame(height: 2)
        }
    }
}
