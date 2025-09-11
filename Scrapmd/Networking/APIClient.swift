//
//  APIClient.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation

@MainActor
struct APIClient {
    struct Result: Decodable, Sendable {
        let title: String
        let markdown: String
        let url: String
        let images: [String: String]
        let leadImageURL: String?

        enum CodingKeys: String, CodingKey {
            case title, markdown, url, images
            case leadImageURL = "lead_image_url"
        }

        func createMetadata() -> ScrapMetadata {
            return ScrapMetadata(title: title, url: url, createdAt: Date(), appVersion: Bundle.main.appVersion)
        }
    }
    
    enum APIError: Error {
        case noData
        case invalidResponse
    }

    static let endpoint = URL(string: "https://api.scrapmd.app/")!
    // static let endpoint = URL(string: "http://localhost:8000/")!

    static func fetch(
        url: URL, 
        title: String? = nil,
        prefetchedHTML: String? = nil
    ) async throws -> (Result, HTTPURLResponse) {
        let session = URLSession.shared
        var request = URLRequest(url: endpoint)
        
        var params = [String: String]()
        if let html = prefetchedHTML {
            params["html"] = html
        }
        params["title"] = title
        params["url"] = url.absoluteString
        params.merge(UserDefaults.shared.additionalParameters,
                     uniquingKeysWith: { key, _ in key })
        
        let data = try JSONEncoder().encode(params)
        request.httpBody = data
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (responseData, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard !responseData.isEmpty else {
            throw APIError.noData
        }
        
        let result = try JSONDecoder().decode(Result.self, from: responseData)
        return (result, httpResponse)
    }
    
    // Legacy completion handler method for backward compatibility during migration
    static func fetch(
        url: URL, title: String? = nil,
        prefetchedHTML: String? = nil,
        completionHandler: @escaping @Sendable (Result?, HTTPURLResponse?, Error?) -> Void
    ) {
        Task {
            do {
                let (result, response) = try await fetch(url: url, title: title, prefetchedHTML: prefetchedHTML)
                await MainActor.run {
                    completionHandler(result, response, nil)
                }
            } catch {
                log(error: error)
                await MainActor.run {
                    completionHandler(nil, nil, error)
                }
            }
        }
    }
}
