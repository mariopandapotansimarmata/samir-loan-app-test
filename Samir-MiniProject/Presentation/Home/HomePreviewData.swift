//
//  HomePreviewData.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

#if DEBUG
import Foundation

enum HomePreviewData {
    static let loans: [LoanSummary] = [
        LoanSummary(
            id: "preview-1",
            borrowerName: "Alya Pratama",
            amount: 5_000,
            interestRate: 0.8,
            termInMonths: 12,
            purpose: "Business expansion",
            riskRating: .a
        ),
        LoanSummary(
            id: "preview-2",
            borrowerName: "Bima Santoso",
            amount: 7_500,
            interestRate: 1.25,
            termInMonths: 18,
            purpose: "Education",
            riskRating: .c
        ),
        LoanSummary(
            id: "preview-3",
            borrowerName: "Citra Lestari",
            amount: 10_000,
            interestRate: 1.75,
            termInMonths: 24,
            purpose: "Home renovation",
            riskRating: .d
        )
    ]
}
#endif
