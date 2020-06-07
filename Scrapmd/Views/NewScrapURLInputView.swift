//
//  NewScrapURLInputView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI

struct NewScrapURLInputView: View {
    @Binding var urlString: String
    @Binding var errorMessage: String
    @Binding var isValid: Bool
    @Binding var isFetching: Bool
    let fetchAction: () -> Void;
    var body: some View {
        VStack {
            HStack {
                Text("Enter URL to fetch")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                Spacer()
            }
            TextField("URL", text: $urlString)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.all)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(11)
                .disabled(isFetching)
            HStack {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                Spacer()
            }
            Spacer().frame(height: 10)
            Button(action: fetchAction) {
                isFetching ?
                    AnyView(ActivityIndicator(
                        isAnimating: .constant(true), style: .medium)) :
                    AnyView(Text("Fetch Web Page"))
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(.all)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(11)
            .disabled(!isValid || isFetching)
            Spacer()
        }
        .padding(.all)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitle("Create New Scrap")
    }
}

struct NewScrapURLInputView_Previews: PreviewProvider {
    static var previews: some View {
        NewScrapURLInputView(
            urlString: .constant("https://"),
            errorMessage: .constant("Hoge"),
            isValid: .constant(true),
            isFetching: .constant(true),
            fetchAction: {}
        )
    }
}
