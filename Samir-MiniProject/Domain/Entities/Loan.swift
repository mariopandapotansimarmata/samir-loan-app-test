//
//  Loan.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

struct Loan: Identifiable, Equatable {
    let id: String
    let amount: Decimal
    let interestRate: Decimal
    let termInMonths: Int
    let purpose: String
    let riskRating: RiskRating
    let borrower: Borrower
    let collateral: Collateral
    let documents: [LoanDocument]
    let installments: [RepaymentInstallment]
}
