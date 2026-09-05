//
//  Endpoint.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

struct Endpoint<Response: Decodable> {
    private enum Target {
        case absolute(URL)
        case relative(baseURL: URL, path: String)
    }

    let method: HTTPMethod
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?
    let timeoutInterval: TimeInterval
    let cachePolicy: URLRequest.CachePolicy

    private let target: Target

    init(
        absoluteURL: URL,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        timeoutInterval: TimeInterval = 30,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        target = .absolute(absoluteURL)
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }

    init(
        baseURL: URL = APIConfiguration.baseURL,
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        timeoutInterval: TimeInterval = 30,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        target = .relative(baseURL: baseURL, path: path)
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }

    func resolveURL() throws -> URL {
        let url: URL

        switch target {
        case let .absolute(absoluteURL):
            url = absoluteURL
        case let .relative(baseURL, path):
            let normalizedPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            url = normalizedPath.isEmpty ? baseURL : baseURL.appendingPathComponent(normalizedPath)
        }

        guard
            let scheme = url.scheme?.lowercased(),
            ["http", "https"].contains(scheme),
            url.host != nil,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            throw NetworkError.invalidURL
        }

        if !queryItems.isEmpty {
            components.queryItems = (components.queryItems ?? []) + queryItems
        }

        guard let resolvedURL = components.url else {
            throw NetworkError.invalidURL
        }

        return resolvedURL
    }
}
