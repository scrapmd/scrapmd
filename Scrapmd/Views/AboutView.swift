//
//  AboutView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/13.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    struct Item: View {
        let label: LocalizedStringKey
        let url: URL

        var body: some View {
            Button(action: {
                UIApplication.shared.open(self.url, options: [:], completionHandler: nil)
            }) {
                Text(label)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
    }

    @Binding var isShown: Bool
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .opacity(0.5)
            Button(action: {

            }) {
                Text("Version \(Bundle.main.appVersion) Build \(Bundle.main.buildNumber)")
                .font(.caption)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .opacity(0.4)
            }
            List {
                Item(label: "Scrapmd Homepage",
                     url: URL(string: NSLocalizedString("https://scrapmd.app/", comment: "Homepage URL"))!)
                Item(label: "Rate Scrapmd",
                     url: URL(string: "https://itunes.apple.com/app/id1517295689?action=write-review")!)
                Item(label: "Submit an Issue", url: Bundle.main.submitIssueURL)
                Item(label: "Contact Author", url: Bundle.main.contactURL)
            }
            Spacer()
            Image("littleapps")
                .opacity(0.5)
            Spacer().frame(height: 20)
            Text(Bundle.main.copyright)
                .font(.caption)
                .multilineTextAlignment(.center)
                .opacity(0.4)
        }
        .navigationBarItems(trailing: Button(action: {
            self.isShown = false
        }) {
            Text("Close")
        })
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView(isShown: .constant(true))
        }
        .environment(\.locale, .init(identifier: "ja"))
    }
}
