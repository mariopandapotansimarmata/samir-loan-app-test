//
//  LoanCardCell.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import UIKit

final class LoanCardCell: UITableViewCell {
    static let reuseIdentifier = String(describing: LoanCardCell.self)

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()

    private let borrowerLabel = LoanCardCell.makeLabel(textStyle: .headline, color: .label)
    private let amountLabel = LoanCardCell.makeLabel(textStyle: .title2, color: .label)
    private let interestLabel = LoanCardCell.makeLabel(textStyle: .subheadline, color: .secondaryLabel)
    private let termLabel = LoanCardCell.makeLabel(textStyle: .subheadline, color: .secondaryLabel)
    private let purposeLabel = LoanCardCell.makeLabel(textStyle: .body, color: .label)

    private let riskLabel: UILabel = {
        let label = makeLabel(textStyle: .caption1, color: .white)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.cornerCurve = .continuous
        label.clipsToBounds = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with viewData: LoanCardViewData) {
        borrowerLabel.text = viewData.borrowerName
        amountLabel.text = viewData.amount
        interestLabel.text = "Interest  \(viewData.interestRate)"
        termLabel.text = "Term  \(viewData.term)"
        purposeLabel.text = "Purpose: \(viewData.purpose)"
        riskLabel.text = "  \(viewData.riskRating)  "
        applyRiskStyle(viewData.riskStyle)

        accessibilityLabel = viewData.borrowerName
        accessibilityValue = "Amount \(viewData.amount), interest \(viewData.interestRate), term \(viewData.term), purpose \(viewData.purpose), \(viewData.riskRating)"
    }

    private func configureView() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }

    private func configureLayout() {
        let headerStack = UIStackView(arrangedSubviews: [borrowerLabel, riskLabel])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 12

        let metricsStack = UIStackView(arrangedSubviews: [interestLabel, termLabel])
        metricsStack.axis = .horizontal
        metricsStack.alignment = .firstBaseline
        metricsStack.distribution = .fillEqually
        metricsStack.spacing = 12

        let contentStack = UIStackView(arrangedSubviews: [
            headerStack,
            amountLabel,
            metricsStack,
            purposeLabel
        ])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 12

        contentView.addSubview(cardView)
        cardView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),

            riskLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
        ])
    }

    private func applyRiskStyle(_ style: LoanCardViewData.RiskStyle) {
        riskLabel.textColor = .white

        switch style {
        case .a:
            riskLabel.backgroundColor = .systemGreen
        case .b:
            riskLabel.backgroundColor = .systemBlue
        case .c:
            riskLabel.backgroundColor = .systemBrown
        case .d:
            riskLabel.backgroundColor = .systemPurple
        case .e:
            riskLabel.backgroundColor = .systemRed
        case .unknown:
            riskLabel.backgroundColor = .systemGray
        }
    }

    private static func makeLabel(textStyle: UIFont.TextStyle, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        label.numberOfLines = 0
        return label
    }
}
