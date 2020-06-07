//
//  NewScrapView.ViewModel.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation
import Combine

extension NewScrapView {
    class ViewModel: ObservableObject {
        @Published var result: APIClient.Result? = nil
        @Published var isFetching = false
        @Published var isValid = false
        @Published var errorMessage = ""
        @Published var urlString = "" {
            didSet {
                if let url = url {
                    self.isValid = url.isValidWebURL
                } else {
                    self.isValid = false
                }
                if !urlString.isEmpty && !self.isValid {
                    self.errorMessage = "Enter valid URL"
                } else {
                    self.errorMessage = ""
                }
            }
        }

        var url: URL? {
            URL(string: urlString)
        }

        func fetch() {
            guard let url = url, !isFetching else { return }
            isFetching = true
            APIClient.fetch(url: url) { (result, _, err)  in
                DispatchQueue.main.async {
                    self.isFetching = false
                    guard let result = result, !result.markdown.isEmpty else {
                        self.errorMessage = "Error fetching from URL"
                        return
                    }
                    self.result = result
                }
            }
        }

    }
}
