//
//  DetailValueCell.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import UIKit

final class DetailValueCell: UITableViewCell {
    static let reuseIdentifier = String(describing: DetailValueCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(title: String, value: String) {
        var configuration = UIListContentConfiguration.valueCell()
        configuration.text = title
        configuration.secondaryText = value
        configuration.textProperties.font = .preferredFont(forTextStyle: .body)
        configuration.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        configuration.secondaryTextProperties.color = .secondaryLabel
        configuration.prefersSideBySideTextAndSecondaryText = true
        contentConfiguration = configuration

        accessibilityLabel = title
        accessibilityValue = value
    }
}
