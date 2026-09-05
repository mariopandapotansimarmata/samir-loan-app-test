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
    enum State {
        case idle
        case loading
        case content([LoanCardViewData])
        case empty
        case error(String)
    }

    @Published private(set) var state: State = .idle

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
        state = .loading

        let fetchLoansUseCase = fetchLoansUseCase
        loadTask = Task { [weak self, fetchLoansUseCase] in
            do {
                let loans = try await fetchLoansUseCase.execute(forceRefresh: forceRefresh)
                try Task.checkCancellation()
                guard let self else { return }

                let sortedLoans = loans.sorted {
                    if $0.termInMonths != $1.termInMonths {
                        return $0.termInMonths < $1.termInMonths
                    }

                    let borrowerComparison = $0.borrower.name.localizedCaseInsensitiveCompare($1.borrower.name)
                    if borrowerComparison != .orderedSame {
                        return borrowerComparison == .orderedAscending
                    }

                    return $0.id < $1.id
                }
                let viewData = sortedLoans.map { LoanCardViewData(loan: $0) }
                state = viewData.isEmpty ? .empty : .content(viewData)
            } catch is CancellationError {
                return
            } catch NetworkError.cancelled {
                return
            } catch {
                self?.state = .error(error.localizedDescription)
            }
        }
    }
}
