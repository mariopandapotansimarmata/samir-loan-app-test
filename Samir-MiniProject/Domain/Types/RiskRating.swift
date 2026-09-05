//
//  RiskRating.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

enum RiskRating: Equatable {
    case a
    case b
    case c
    case d
    case e
    case unknown(String)

    init(rawValue: String) {
        switch rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() {
        case "A": self = .a
        case "B": self = .b
        case "C": self = .c
        case "D": self = .d
        case "E": self = .e
        default: self = .unknown(rawValue)
        }
    }

    var displayValue: String {
        switch self {
        case .a: "A"
        case .b: "B"
        case .c: "C"
        case .d: "D"
        case .e: "E"
        case let .unknown(value): value
        }
    }
}
