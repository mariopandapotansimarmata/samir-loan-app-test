//
//  AppCoordinator.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showHome()
    }

    private func showHome() {
        #if DEBUG
        let loans = HomePreviewData.loans
        #else
        let loans: [LoanSummary] = []
        #endif

        let viewController = HomeViewController(loans: loans)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
