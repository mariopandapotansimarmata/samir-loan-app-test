//
//  LoanRepository.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

enum LoanRepositoryError: Error, Equatable {
    case loanNotFound
}

protocol LoanRepository: AnyObject {
    func fetchLoans(forceRefresh: Bool) async throws -> [Loan]
    func loan(id: Loan.ID) async throws -> Loan
}
