//
//  LoanDetailViewController.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Combine
import UIKit

final class LoanDetailViewController: UIViewController {
    private let viewModel: LoanDetailViewModel
    private weak var coordinator: LoanDetailCoordinating?
    private var viewData: LoanDetailViewData?
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.register(DetailValueCell.self, forCellReuseIdentifier: DetailValueCell.reuseIdentifier)
        tableView.register(InstallmentCell.self, forCellReuseIdentifier: InstallmentCell.reuseIdentifier)
        tableView.register(DocumentCell.self, forCellReuseIdentifier: DocumentCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyDocumentCell")
        return tableView
    }()

    init(
        viewModel: LoanDetailViewModel,
        coordinator: LoanDetailCoordinating
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
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
    }

    private func configureView() {
        title = "Loan Detail"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .never
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
        viewModel.$loan
            .sink { [weak self] loan in
                self?.viewData = loan
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension LoanDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewData == nil ? 0 : LoanDetailSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let viewData,
            let detailSection = LoanDetailSection(rawValue: section)
        else {
            return 0
        }

        switch detailSection {
        case .borrower:
            return 3
        case .collateral:
            return 2
        case .repaymentSchedule:
            return viewData.installments.count
        case .documents:
            return max(viewData.documents.count, 1)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        LoanDetailSection(rawValue: section)?.title
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let viewData,
            let section = LoanDetailSection(rawValue: indexPath.section)
        else {
            return UITableViewCell()
        }

        switch section {
        case .borrower:
            let values = [
                ("Name", viewData.borrowerName),
                ("Email", viewData.borrowerEmail),
                ("Credit score", viewData.creditScore)
            ]
            return makeDetailCell(tableView, indexPath: indexPath, value: values[indexPath.row])
        case .collateral:
            let values = [
                ("Type", viewData.collateralType),
                ("Value", viewData.collateralValue)
            ]
            return makeDetailCell(tableView, indexPath: indexPath, value: values[indexPath.row])
        case .repaymentSchedule:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: InstallmentCell.reuseIdentifier,
                for: indexPath
            ) as? InstallmentCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewData.installments[indexPath.row])
            return cell
        case .documents:
            guard !viewData.documents.isEmpty else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "EmptyDocumentCell",
                    for: indexPath
                )
                var configuration = cell.defaultContentConfiguration()
                configuration.text = "No documents available"
                configuration.textProperties.color = .secondaryLabel
                cell.contentConfiguration = configuration
                cell.selectionStyle = .none
                cell.accessoryType = .none
                return cell
            }

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DocumentCell.reuseIdentifier,
                for: indexPath
            ) as? DocumentCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewData.documents[indexPath.row])
            return cell
        }
    }

    private func makeDetailCell(
        _ tableView: UITableView,
        indexPath: IndexPath,
        value: (title: String, value: String)
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DetailValueCell.reuseIdentifier,
            for: indexPath
        ) as? DetailValueCell else {
            return UITableViewCell()
        }

        cell.configure(title: value.title, value: value.value)
        return cell
    }
}

extension LoanDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard
            LoanDetailSection(rawValue: indexPath.section) == .documents,
            let document = viewData?.documents[safe: indexPath.row]
        else {
            return
        }

        coordinator?.showDocumentPreview(for: document.url)
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
