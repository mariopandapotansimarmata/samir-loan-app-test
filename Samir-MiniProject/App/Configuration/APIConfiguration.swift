//
//  APIConfiguration.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

enum APIConfiguration {
    static let baseURL: URL = {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 3001

        guard let url = components.url else {
            preconditionFailure("Default base URL configuration is invalid.")
        }

        return url
    }()
}
