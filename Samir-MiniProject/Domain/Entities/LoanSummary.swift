//
//  LoanSummary.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

struct LoanSummary: Identifiable, Equatable {
    let id: String
    let borrowerName: String
    let amount: Decimal
    let interestRate: Decimal
    let termInMonths: Int
    let purpose: String
    let riskRating: RiskRating
}
