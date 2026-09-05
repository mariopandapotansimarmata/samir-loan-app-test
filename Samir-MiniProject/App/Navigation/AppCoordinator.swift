//
//  AppCoordinator.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

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
        let viewController = appContainer.makeHomeViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }
}
