//
//  NetworkSessionFactory.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

#if canImport(netfox) && NETFOX_ENABLED
import netfox
#endif

enum NetworkSessionFactory {
    static func makeDefaultSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true

        #if canImport(netfox) && NETFOX_ENABLED
        addNetfoxProtocolIfNeeded(to: configuration)
        #endif

        return URLSession(configuration: configuration)
    }

    #if canImport(netfox) && NETFOX_ENABLED
    private static func addNetfoxProtocolIfNeeded(to configuration: URLSessionConfiguration) {
        var protocolClasses = configuration.protocolClasses ?? []
        let containsNetfox = protocolClasses.contains {
            ObjectIdentifier($0) == ObjectIdentifier(NFXProtocol.self)
        }

        if !containsNetfox {
            protocolClasses.insert(NFXProtocol.self, at: 0)
            configuration.protocolClasses = protocolClasses
        }
    }
    #endif
}
