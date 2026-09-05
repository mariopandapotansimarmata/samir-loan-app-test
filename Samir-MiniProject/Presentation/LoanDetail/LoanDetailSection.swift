//
//  LoanDetailSection.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

enum LoanDetailSection: Int, CaseIterable {
    case borrower
    case collateral
    case repaymentSchedule
    case documents

    var title: String {
        switch self {
        case .borrower:
            "Borrower"
        case .collateral:
            "Collateral"
        case .repaymentSchedule:
            "Repayment Schedule"
        case .documents:
            "Documents"
        }
    }
}
