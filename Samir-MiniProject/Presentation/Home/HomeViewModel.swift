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
    @Published private(set) var selectedSort: LoanSort = .none

    private let fetchLoansUseCase: FetchLoansUseCase
    private var sourceLoans: [Loan] = []
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

                self.sourceLoans = loans
                self.applySelectedSort()
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

    func sortLoans(by sort: LoanSort) {
        selectedSort = sort
        applySelectedSort()
    }

    private func applySelectedSort() {
        guard selectedSort != .none else {
            loans = sourceLoans
            return
        }

        loans = sourceLoans.sorted { lhs, rhs in
            let comparison = compare(lhs, rhs, using: selectedSort)

            if comparison == .orderedSame {
                return lhs.id < rhs.id
            }

            return comparison == .orderedAscending
        }
    }

    private func compare(_ lhs: Loan, _ rhs: Loan, using sort: LoanSort) -> ComparisonResult {
        switch sort {
        case .none:
            return .orderedSame
        case .amountAscending:
            return compareValue(lhs.amount, rhs.amount)
        case .amountDescending:
            return compareValue(rhs.amount, lhs.amount)
        case .termAscending:
            return compareValue(lhs.termInMonths, rhs.termInMonths)
        case .termDescending:
            return compareValue(rhs.termInMonths, lhs.termInMonths)
        }
    }

    private func compareValue<Value: Comparable>(_ lhs: Value, _ rhs: Value) -> ComparisonResult {
        if lhs == rhs {
            return .orderedSame
        }

        return lhs < rhs ? .orderedAscending : .orderedDescending
    }
}
