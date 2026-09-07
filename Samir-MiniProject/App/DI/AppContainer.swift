//
//  AppContainer.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

final class AppContainer {
    private let networkManager: NetworkManaging

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
        networkManager: NetworkManaging = URLSessionNetworkManager()
    ) {
        self.networkManager = networkManager
    }
}
