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
    private unowned let appContainer: AppContainer

    init(navigationController: UINavigationController, appContainer: AppContainer) {
        self.navigationController = navigationController
        self.appContainer = appContainer
    }

    func start() {
        showHome()
    }

    private func showHome() {
        let viewController = appContainer.makeHomeViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }

    func navigateToLoanDetailScreen(loan: Loan) {
        let viewController = appContainer.makeLoanDetailViewController(loan: loan)
        viewController.onDocumentSelected = { [weak self] url in
            self?.showDocumentPreview(url: url)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showDocumentPreview(url: URL) {
        let viewController = SFSafariViewController(url: url)
        navigationController.present(viewController, animated: true)
    }
}
