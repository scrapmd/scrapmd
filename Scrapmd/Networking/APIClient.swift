//
//  APIClient.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/05.
//  Copyright © 2020 Atsushi Nagase. All rights reserved.
//

import Foundation

struct APIClient {
    struct Params: Encodable {
        var html: String?
        var url: String
    }
    struct Result: Decodable {
        var title: String
        var markdown: String
        var url: String
        var images: [String: String]
    }
    enum APIError: Error {
        case noData
    }

    typealias CompletionHandler = (Result?, HTTPURLResponse?, Error?) -> Void

//    static let endpoint = URL(string: "https://api.scrapmd.app/")!
    static let endpoint = URL(string: "http://localhost:8000/")!

    static func fetch(url: URL, prefetchedHTML: String? = nil, completionHandler: @escaping CompletionHandler) {
        let session = URLSession.shared
        var req = URLRequest(url: endpoint)
        let params = Params(html: prefetchedHTML, url: url.absoluteString)
        let data = try! JSONEncoder().encode(params)
        req.httpBody = data
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        session.dataTask(with: req) { (data, res, err) in
            guard let res = res as? HTTPURLResponse else { fatalError() }
            if let err = err {
                completionHandler(nil, res, err)
                return
            }
            guard let data = data else {
                completionHandler(nil, res, APIError.noData)
                return
            }
            do {
                print(String(data: data, encoding: .utf8))
                let result = try JSONDecoder().decode(Result.self, from: data)
                completionHandler(result, res, nil)
            } catch {
                completionHandler(nil, res, error)
            }
        }.resume()
    }
}
