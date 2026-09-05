//
//  HomeViewModel.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel {
    @Published private(set) var loans: [Loan] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let fetchLoansUseCase: FetchLoansUseCase
    private var loadTask: Task<Void, Never>?

    init(fetchLoansUseCase: FetchLoansUseCase) {
        self.fetchLoansUseCase = fetchLoansUseCase
    }

    deinit {
        loadTask?.cancel()
    }

    func loadLoans(forceRefresh: Bool = false) {
        loadTask?.cancel()
        isLoading = true
        errorMessage = nil

        let fetchLoansUseCase = fetchLoansUseCase
        loadTask = Task { [weak self, fetchLoansUseCase] in
            do {
                let loans = try await fetchLoansUseCase.execute(forceRefresh: forceRefresh)
                try Task.checkCancellation()
                guard let self else { return }

                self.loans = loans.sorted {
                    if $0.termInMonths != $1.termInMonths {
                        return $0.termInMonths < $1.termInMonths
                    }

                    let borrowerComparison = $0.borrower.name.localizedCaseInsensitiveCompare($1.borrower.name)
                    if borrowerComparison != .orderedSame {
                        return borrowerComparison == .orderedAscending
                    }

                    return $0.id < $1.id
                }
                self.isLoading = false
            } catch is CancellationError {
                return
            } catch NetworkError.cancelled {
                return
            } catch {
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            }
        }
    }
}
