//
//  ViewElementsForMainScreen.swift
//  YanDo
//
//  Created by Александра Маслова on 27.06.2023.
//

import UIKit

class ViewElementsForMainScreen {
    // table
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        let icon = UIImageView(image: SystemImages.calendar.uiImage)
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
         icon.image = Images.chevron.uiImage
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 7 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 12 / Aligners.modelHight * Aligners.height).isActive = true
        return icon
    }()
    // add item
    let newItemButton: UIImageView = {
        let imageView = UIImageView(image: Images.plus.uiImage)
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
        text.text = Text.new
        text.font = UIFont.body
        text.textColor = UIColor.tertiaryLabel
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
}
