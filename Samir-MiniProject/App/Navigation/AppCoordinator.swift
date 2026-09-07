//
//  AppCoordinator.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import SafariServices
import UIKit

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let appContainer: AppContainer

    init(navigationController: UINavigationController, appContainer: AppContainer) {
        self.navigationController = navigationController
        self.appContainer = appContainer
    }

    func start() {
        showHome()
    }

    private func showHome() {
        let viewModel = HomeViewModel(fetchLoansUseCase: appContainer.fetchLoansUseCase)
        let viewController = HomeViewController(
            viewModel: viewModel,
            coordinator: self
        )
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension AppCoordinator: HomeCoordinating {
    func showLoanDetail(for loan: Loan) {
        let viewModel = LoanDetailViewModel(loan: loan)
        let viewController = LoanDetailViewController(
            viewModel: viewModel,
            coordinator: self
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: LoanDetailCoordinating {
    func showDocumentPreview(for url: URL) {
        let viewController = SFSafariViewController(url: url)
        navigationController.present(viewController, animated: true)
    }
}
