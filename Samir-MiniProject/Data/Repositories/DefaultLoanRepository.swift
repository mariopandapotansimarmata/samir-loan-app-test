//
//  DefaultLoanRepository.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

final class DefaultLoanRepository: LoanRepository {
    private let networkManager: NetworkManaging
    private let mapper: LoanMapper

    private var cachedLoans: [Loan]?

    init(networkManager: NetworkManaging, mapper: LoanMapper) {
        self.networkManager = networkManager
        self.mapper = mapper
    }

    func fetchLoans(forceRefresh: Bool) async throws -> [Loan] {
        if !forceRefresh, let cachedLoans {
            return cachedLoans
        }

        let endpoint = LoanEndpoint.loans(forceRefresh: forceRefresh)
        let loanDTOs = try await networkManager.request(endpoint)
        let loans = try loanDTOs.map(mapper.map)
        cachedLoans = loans
        return loans
    }

    func loan(id: Loan.ID) async throws -> Loan {
        let loans = try await fetchLoans(forceRefresh: false)

        guard let loan = loans.first(where: { $0.id == id }) else {
            throw LoanRepositoryError.loanNotFound
        }

        return loan
    }
}
