//
//  DocumentURLResolver.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

enum DocumentURLResolverError: Error, Equatable {
    case invalidURL
    case unsupportedScheme
}

struct DocumentURLResolver {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func resolve(_ value: String) throws -> URL {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            throw DocumentURLResolverError.invalidURL
        }

        if let components = URLComponents(string: trimmedValue), components.scheme != nil {
            guard
                let scheme = components.scheme?.lowercased(),
                ["http", "https"].contains(scheme)
            else {
                throw DocumentURLResolverError.unsupportedScheme
            }

            guard let url = components.url, url.host != nil else {
                throw DocumentURLResolverError.invalidURL
            }

            return url
        }

        let normalizedPath = trimmedValue.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !normalizedPath.isEmpty else {
            throw DocumentURLResolverError.invalidURL
        }

        return baseURL.appendingPathComponent(normalizedPath)
    }
}
