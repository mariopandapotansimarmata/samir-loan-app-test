//
//  URLSessionNetworkManager.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

final class URLSessionNetworkManager: NetworkManaging {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = NetworkSessionFactory.makeDefaultSession(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func request<Response: Decodable>(
        _ endpoint: Endpoint<Response>
    ) async throws -> Response {
        do {
            try Task.checkCancellation()

            let request = try makeURLRequest(for: endpoint)
            let (data, response) = try await session.data(for: request)

            try Task.checkCancellation()

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.httpStatus(httpResponse.statusCode)
            }

            do {
                return try decoder.decode(Response.self, from: data)
            } catch is DecodingError {
                throw NetworkError.decoding
            }
        } catch let error as NetworkError {
            throw error
        } catch is CancellationError {
            throw NetworkError.cancelled
        } catch let error as URLError {
            throw mapURLError(error)
        } catch {
            throw NetworkError.transport
        }
    }

    private func makeURLRequest<Response: Decodable>(
        for endpoint: Endpoint<Response>
    ) throws -> URLRequest {
        let url = try endpoint.resolveURL()
        var request = URLRequest(
            url: url,
            cachePolicy: endpoint.cachePolicy,
            timeoutInterval: endpoint.timeoutInterval
        )
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        endpoint.headers.forEach { field, value in
            request.setValue(value, forHTTPHeaderField: field)
        }

        return request
    }

    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .cancelled:
            .cancelled
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            .notConnected
        case .timedOut:
            .timedOut
        default:
            .transport
        }
    }
}
