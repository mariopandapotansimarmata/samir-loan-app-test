//
//  LoanDetailViewData.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

struct LoanDetailViewData {
    struct Installment {
        let dueDate: String
        let amountDue: String
    }

    struct Document {
        let type: String
        let url: URL
    }

    let borrowerName: String
    let borrowerEmail: String
    let creditScore: String
    let collateralType: String
    let collateralValue: String
    let installments: [Installment]
    let documents: [Document]

    init(loan: Loan) {
        borrowerName = loan.borrower.name
        borrowerEmail = loan.borrower.email
        creditScore = String(loan.borrower.creditScore)
        collateralType = loan.collateral.type
        collateralValue = Self.numberFormatter.string(
            from: NSDecimalNumber(decimal: loan.collateral.value)
        ) ?? "—"
        installments = loan.installments.map {
            Installment(
                dueDate: Self.dateFormatter.string(from: $0.dueDate),
                amountDue: Self.numberFormatter.string(
                    from: NSDecimalNumber(decimal: $0.amountDue)
                ) ?? "—"
            )
        }
        documents = loan.documents.map {
            Document(type: $0.type, url: $0.url)
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

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
