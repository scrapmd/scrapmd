//
//  APIClient.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import Foundation

struct APIClient {
    struct Params: Encodable {
        var html: String?
        var title: String?
        var url: String
    }
    struct Result: Decodable {
        var title: String
        var markdown: String
        var url: String
        var images: [String: String]
        var leadImageURL: String?

        // swiftlint:disable:next nesting
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
    }

    typealias CompletionHandler = (Result?, HTTPURLResponse?, Error?) -> Void

    static let endpoint = URL(string: "https://api.scrapmd.app/")!
    // static let endpoint = URL(string: "http://localhost:8000/")!

    static func fetch(url: URL, title: String? = nil, prefetchedHTML: String? = nil,
                      completionHandler: @escaping CompletionHandler) {
        let session = URLSession.shared
        var req = URLRequest(url: endpoint)
        let params = Params(html: prefetchedHTML, title: title, url: url.absoluteString)
        do {
            let data = try JSONEncoder().encode(params)
            req.httpBody = data
        } catch {
            fatalError(error.localizedDescription)
        }
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: req) { (data, res, err) in
            guard let res = res as? HTTPURLResponse else { fatalError() }
            if let err = err {
                log(error: err)
                completionHandler(nil, res, err)
                return
            }
            guard let data = data else {
                completionHandler(nil, res, APIError.noData)
                return
            }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                completionHandler(result, res, nil)
            } catch {
                completionHandler(nil, res, error)
            }
        }.resume()
    }
}
