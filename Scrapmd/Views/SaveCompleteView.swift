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
    @State var appeared = false
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: UIFont.systemFontSize * 8, height: UIFont.systemFontSize * 8, alignment: .center)
                .foregroundColor(.green)
                .scaleEffect(appeared ? 1 : 0.5)
                .animation(.spring(dampingFraction: 0.5))
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
        }).onAppear {
            self.appeared = true
        }
    }
}

struct SaveCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SaveCompleteView(savedPath: nil) { _ in }
        }
    }
}
