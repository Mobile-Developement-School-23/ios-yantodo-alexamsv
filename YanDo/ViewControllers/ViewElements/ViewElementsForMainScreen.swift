//
//  ViewElementsForMainScreen.swift
//  YanDo
//
//  Created by Александра Маслова on 27.06.2023.
//

import UIKit

class ViewElementsForMainScreen {
    // inf panel
    let netIndicator: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 24 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 24 / Aligners.modelHight * Aligners.height).isActive = true
        return icon
    }()
    let informationView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.widthAnchor.constraint(equalToConstant: 311 / Aligners.modelWidth * Aligners.width).isActive = true
        return stack
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
    // table
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalToConstant: 343 / Aligners.modelWidth * Aligners.width).isActive = true
        return tableView
    }()
    // cells components
     let markerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
     let cellsLabel: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
         stack.spacing = 4 / Aligners.modelHight * Aligners.height
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let cellsInf: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4 / Aligners.modelWidth * Aligners.width
        stack.alignment = .leading
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let importanceIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 10 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 18 / Aligners.modelHight * Aligners.height).isActive = true
        return icon
    }()
     let title: UILabel = {
        let text = UILabel()
         text.font = UIFont.body
         text.textColor = UIColor.primaryLabel
        text.numberOfLines = 3
        text.lineBreakMode = .byTruncatingTail
        text.widthAnchor.constraint(equalToConstant: 250 / Aligners.modelWidth * Aligners.width).isActive = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let deadlineView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImageView(image: UIImage(systemName: "calendar"))
        icon.tintColor = UIColor.tertiaryLabel
        icon.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(icon)
        return stack
    }()
    let deadlineTitle: UILabel = {
        let text = UILabel()
        text.font = UIFont.subhead
        text.textColor = UIColor.tertiaryLabel
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
     let chevronIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Chevron")
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 7 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 12 / Aligners.modelHight * Aligners.height).isActive = true
        return icon
    }()
    // add item
    let newItemButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Plus"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.layer.shadowColor = UIColor.primaryLabel?.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 4
        return imageView
    }()
    let newItemCell: UILabel = {
        let text = UILabel()
        text.text = "Новое"
        text.font = UIFont.body
        text.textColor = UIColor.tertiaryLabel
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
}
