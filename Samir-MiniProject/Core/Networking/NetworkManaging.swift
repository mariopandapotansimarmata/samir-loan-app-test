//
//  NetworkManaging.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

protocol NetworkManaging {
    func request<Response: Decodable>(
        _ endpoint: Endpoint<Response>
    ) async throws -> Response
}
