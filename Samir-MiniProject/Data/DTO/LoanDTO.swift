//
//  LoanDTO.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

struct LoanDTO: Decodable {
    let id: String
    let amount: Decimal
    let interestRate: Decimal
    let term: Int
    let purpose: String
    let riskRating: String
    let borrower: BorrowerDTO
    let collateral: CollateralDTO
    let documents: [LoanDocumentDTO]
    let repaymentSchedule: RepaymentScheduleDTO
}
