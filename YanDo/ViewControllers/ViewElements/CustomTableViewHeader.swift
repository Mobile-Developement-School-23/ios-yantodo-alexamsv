//
//  CustomTableViewHeader.swift
//  YanDo
//
//  Created by Александра Маслова on 10.07.2023.
//
// swiftlint:disable line_length

import UIKit

class CustomTableViewHeader: UIView {
    let netIndicator: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    let completedLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont.subhead
        text.textColor = UIColor.tertiaryLabel
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let showButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать", for: .normal)
        button.titleLabel?.font = UIFont.subhead
        button.setTitleColor(UIColor.blueColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.primaryBack
        addSubview(netIndicator)
        addSubview(completedLabel)
        addSubview(showButton)
        NSLayoutConstraint.activate([
            netIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width),
            netIndicator.topAnchor.constraint(equalTo: self.topAnchor),
            netIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            completedLabel.leadingAnchor.constraint(equalTo: netIndicator.trailingAnchor, constant: 8 / Aligners.modelWidth * Aligners.width),
            completedLabel.topAnchor.constraint(equalTo: self.topAnchor),
            completedLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            showButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width),
            showButton.topAnchor.constraint(equalTo: self.topAnchor),
            showButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// swiftlint:enable line_length
