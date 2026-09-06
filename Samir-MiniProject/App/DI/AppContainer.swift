//
//  AppContainer.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import UIKit

final class AppContainer {
    private let networkManager: NetworkManaging
    private let navigationController: UINavigationController

    lazy var appCoordinator = AppCoordinator(
        navigationController: navigationController,
        appContainer: self
    )

    private lazy var documentURLResolver = DocumentURLResolver(
        baseURL: APIConfiguration.documentBaseURL
    )
    private lazy var loanMapper = LoanMapper(
        documentURLResolver: documentURLResolver
    )
    private lazy var loanRepository: LoanRepository = DefaultLoanRepository(
        networkManager: networkManager,
        mapper: loanMapper
    )
    private(set) lazy var fetchLoansUseCase: FetchLoansUseCase = DefaultFetchLoansUseCase(
        repository: loanRepository
    )

    init(
        navigationController: UINavigationController,
        networkManager: NetworkManaging = URLSessionNetworkManager()
    ) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
}
