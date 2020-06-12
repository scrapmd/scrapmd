//
//  SaveCompleteView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/12.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct SaveCompleteView: View {
    let savedPath: FileKitPath?
    let action: (_ path: FileKitPath?) -> Void
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: UIFont.systemFontSize * 3, height: UIFont.systemFontSize * 3, alignment: .center)
                .foregroundColor(.green)
            Spacer().frame(height: 40)
            Text("Saved!").font(.largeTitle)
            Spacer().frame(height: 40)
            Button(action: { self.action(self.savedPath) }) {
                Text("View Scrap")
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.all)
                .background(Color.accentColor)
                .cornerRadius(11)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Button(action: {
            self.action(nil)
        }) {
            Text("Done")
        })
    }
}

struct SaveCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SaveCompleteView(savedPath: nil) { _ in }
        }
    }
}
