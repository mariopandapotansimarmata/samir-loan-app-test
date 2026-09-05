//
//  DocumentCell.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import UIKit

final class DocumentCell: UITableViewCell {
    static let reuseIdentifier = String(describing: DocumentCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with document: LoanDetailViewData.Document) {
        var configuration = UIListContentConfiguration.subtitleCell()
        configuration.text = document.type
        configuration.secondaryText = "Open document"
        configuration.image = UIImage(systemName: "doc.text")
        configuration.imageProperties.tintColor = .systemBlue
        configuration.textProperties.font = .preferredFont(forTextStyle: .body)
        configuration.secondaryTextProperties.font = .preferredFont(forTextStyle: .subheadline)
        configuration.secondaryTextProperties.color = .secondaryLabel
        contentConfiguration = configuration

        accessibilityLabel = document.type
        accessibilityHint = "Opens document preview"
    }
}
