//
//  InstallmentCell.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import UIKit

final class InstallmentCell: UITableViewCell {
    static let reuseIdentifier = String(describing: InstallmentCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with installment: LoanDetailViewData.Installment) {
        var configuration = UIListContentConfiguration.subtitleCell()
        configuration.text = installment.dueDate
        configuration.secondaryText = "Amount due: \(installment.amountDue)"
        configuration.textProperties.font = .preferredFont(forTextStyle: .body)
        configuration.secondaryTextProperties.font = .preferredFont(forTextStyle: .subheadline)
        configuration.secondaryTextProperties.color = .secondaryLabel
        contentConfiguration = configuration

        accessibilityLabel = "Due date \(installment.dueDate)"
        accessibilityValue = "Amount due \(installment.amountDue)"
    }
}
