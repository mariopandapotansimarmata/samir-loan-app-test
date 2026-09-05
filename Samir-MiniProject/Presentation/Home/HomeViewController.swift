//
//  HomeViewController.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Combine
import UIKit

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private unowned let appContainer: AppContainer
    private var loans: [Loan] = []
    private var cancellables = Set<AnyCancellable>()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshLoans), for: .valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 190
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.register(LoanCardCell.self, forCellReuseIdentifier: LoanCardCell.reuseIdentifier)
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var retryButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Retry"
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(retryLoading), for: .touchUpInside)
        return button
    }()

    private lazy var stateView: UIView = {
        let containerView = UIView()

        let stackView = UIStackView(arrangedSubviews: [
            activityIndicator,
            stateLabel,
            retryButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16

        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -24)
        ])

        return containerView
    }()

    init(viewModel: HomeViewModel, appContainer: AppContainer) {
        self.viewModel = viewModel
        self.appContainer = appContainer
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        bindViewModel()
        viewModel.loadLoans()
    }

    private func configureView() {
        title = "Loans"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .always
    }

    private func configureLayout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        Publishers.CombineLatest3(
            viewModel.$loans,
            viewModel.$isLoading,
            viewModel.$errorMessage
        )
            .sink { [weak self] loans, isLoading, errorMessage in
                self?.render(
                    loans: loans,
                    isLoading: isLoading,
                    errorMessage: errorMessage
                )
            }
            .store(in: &cancellables)
    }

    private func render(
        loans: [Loan],
        isLoading: Bool,
        errorMessage: String?
    ) {
        self.loans = loans

        if isLoading, loans.isEmpty {
            showState(message: "Loading loans...", isLoading: true, canRetry: false)
            return
        }

        if let errorMessage {
            refreshControl.endRefreshing()

            if loans.isEmpty {
                showState(message: errorMessage, isLoading: false, canRetry: true)
            } else {
                tableView.backgroundView = nil
                tableView.reloadData()
                presentRefreshError(errorMessage)
            }
            return
        }

        guard !isLoading else {
            tableView.backgroundView = nil
            tableView.reloadData()
            return
        }

        refreshControl.endRefreshing()
        tableView.reloadData()

        if loans.isEmpty {
            showState(message: "No loans available.", isLoading: false, canRetry: false)
        } else {
            tableView.backgroundView = nil
        }
    }

    private func showState(message: String, isLoading: Bool, canRetry: Bool) {
        stateLabel.text = message
        retryButton.isHidden = !canRetry

        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        tableView.backgroundView = stateView
    }

    private func presentRefreshError(_ message: String) {
        guard presentedViewController == nil else { return }

        let alert = UIAlertController(title: "Unable to Refresh", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.loadLoans(forceRefresh: true)
        })
        present(alert, animated: true)
    }

    @objc
    private func refreshLoans() {
        viewModel.loadLoans(forceRefresh: true)
    }

    @objc
    private func retryLoading() {
        viewModel.loadLoans(forceRefresh: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        appContainer.appCoordinator.navigateToLoanDetailScreen(loan: loans[indexPath.row])
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loans.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LoanCardCell.reuseIdentifier,
            for: indexPath
        ) as? LoanCardCell else {
            return UITableViewCell()
        }

        cell.configure(with: LoanCardViewData(loan: loans[indexPath.row]))
        return cell
    }
}
