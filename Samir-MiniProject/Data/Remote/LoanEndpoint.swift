//
//  LoanEndpoint.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

enum LoanEndpoint {
    static func loans(forceRefresh: Bool) -> Endpoint<[LoanDTO]> {
        Endpoint(
            baseURL: APIConfiguration.apiBaseURL,
            path: "json/loans.json",
            method: .get,
            headers: ["Accept": "application/json"],
            cachePolicy: forceRefresh ? .reloadIgnoringLocalCacheData : .useProtocolCachePolicy
        )
    }
}
