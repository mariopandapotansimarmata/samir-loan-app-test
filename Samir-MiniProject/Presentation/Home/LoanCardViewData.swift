//
//  LoanCardViewData.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

struct LoanCardViewData {
    enum RiskStyle {
        case a
        case b
        case c
        case d
        case e
        case unknown
    }

    let id: Loan.ID
    let borrowerName: String
    let amount: String
    let interestRate: String
    let term: String
    let purpose: String
    let riskRating: String
    let riskStyle: RiskStyle

    init(loan: Loan) {
        id = loan.id
        borrowerName = loan.borrower.name
        amount = "$\(Self.numberFormatter.string(from: NSDecimalNumber(decimal: loan.amount)) ?? "—")"
        interestRate = "\(Self.numberFormatter.string(from: NSDecimalNumber(decimal: loan.interestRate)) ?? "—")%"
        term = "\(loan.termInMonths) months"
        purpose = loan.purpose
        riskRating = "Risk \(loan.riskRating.displayValue)"

        switch loan.riskRating {
        case .a:
            riskStyle = .a
        case .b:
            riskStyle = .b
        case .c:
            riskStyle = .c
        case .d:
            riskStyle = .d
        case .e:
            riskStyle = .e
        case .unknown:
            riskStyle = .unknown
        }
    }

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
