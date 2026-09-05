//
//  LoanDetailViewModel.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Combine

@MainActor
final class LoanDetailViewModel {
    @Published private(set) var loan: LoanDetailViewData

    init(loan: Loan) {
        self.loan = LoanDetailViewData(loan: loan)
    }
}
