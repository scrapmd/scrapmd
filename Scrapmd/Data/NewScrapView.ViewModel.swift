//
//  NewScrapView.ViewModel.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Combine
import Foundation

extension NewScrapView {
    @MainActor
    @Observable
    class ViewModel {
        var result: APIClient.Result?
        var isFetching = false
        var isFetched = false
        var isValid = false
        var errorMessage = ""
        var urlString = "" {
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

        func fetch() async {
            guard let url = url, !isFetching else { return }
            isFetching = true
            errorMessage = ""

            do {
                let (result, _) = try await APIClient.fetch(url: url)

                if result.markdown.isEmpty {
                    self.errorMessage = "This site is not supported"
                } else {
                    self.result = result
                    self.isFetched = true
                }
            } catch {
                self.errorMessage = "Error fetching from URL: \(error.localizedDescription)"
            }

            self.isFetching = false
        }
    }
}
