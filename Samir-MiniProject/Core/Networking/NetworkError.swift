//
//  NetworkError.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case notConnected
    case timedOut
    case transport
    case decoding
    case cancelled
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The request URL is invalid."
        case .invalidResponse:
            "The server returned an invalid response."
        case let .httpStatus(statusCode):
            "The server returned status code \(statusCode)."
        case .notConnected:
            "No internet connection is available."
        case .timedOut:
            "The request timed out."
        case .transport:
            "A network connection error occurred."
        case .decoding:
            "The server response could not be read."
        case .cancelled:
            "The request was cancelled."
        }
    }
}
