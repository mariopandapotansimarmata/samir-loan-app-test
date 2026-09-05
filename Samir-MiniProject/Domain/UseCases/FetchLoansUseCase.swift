//
//  FetchLoansUseCase.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

protocol FetchLoansUseCase {
    func execute(forceRefresh: Bool) async throws -> [Loan]
}

final class DefaultFetchLoansUseCase: FetchLoansUseCase {
    private let repository: LoanRepository

    init(repository: LoanRepository) {
        self.repository = repository
    }

    func execute(forceRefresh: Bool) async throws -> [Loan] {
        try await repository.fetchLoans(forceRefresh: forceRefresh)
    }
}
