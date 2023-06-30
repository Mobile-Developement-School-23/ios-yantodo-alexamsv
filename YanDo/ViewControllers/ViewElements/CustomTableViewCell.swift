//
//  CustomTableViewCell.swift
//  YanDo
//
//  Created by Александра Маслова on 28.06.2023.
//
// swiftlint:disable line_length

import UIKit

// MARK: - protocol
// протокол для изменения состояния isCompleted по нажатию кнопки
protocol CustomTableViewCellDelegate: AnyObject {
    func toDoItemIsCompleted(in cell: CustomTableViewCell)
    func toDoItemIsPending(in cell: CustomCompletedTableViewCell)
}

// MARK: - pending items
class CustomTableViewCell: UITableViewCell {
    let elements = ViewElementsForMainScreen()
    weak var delegate: CustomTableViewCellDelegate?
    // item
    var item: ToDoItem? {
        didSet {
            configureCell()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         configureCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // Сбрасываем значения ячейки
        item = nil
        elements.markerButton.setImage(nil, for: .normal)
        elements.cellsLabel.arrangedSubviews.forEach { $0.removeFromSuperview() }
        elements.cellsInf.arrangedSubviews.forEach { $0.removeFromSuperview() }
        elements.importanceIcon.image = nil
        elements.title.text = nil
        elements.deadlineTitle.text = nil
    }
    // cells settings
    private func configureCell() {
        guard let item = item else { return }
        if !item.isCompleted {
            if item.importance == .high {
                elements.markerButton.setImage(UIImage(named: "RedMarker"), for: .normal)
                elements.importanceIcon.image = UIImage(named: "ImportanceHight")
                elements.cellsInf.addArrangedSubview(elements.importanceIcon)
            } else {
                elements.markerButton.setImage(UIImage(named: "PendingMarker"), for: .normal)
            }
            elements.title.text = item.text
            elements.cellsLabel.addArrangedSubview(elements.title)
            if let deadline = item.deadline {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.dateFormat = "d MMMM"
                let formattedDeadline = formatter.string(from: deadline)
                elements.deadlineTitle.text = formattedDeadline
                elements.deadlineView.addArrangedSubview(elements.deadlineTitle)
                elements.cellsLabel.addArrangedSubview(elements.deadlineView)
            }
            elements.cellsInf.addArrangedSubview(elements.cellsLabel)
            elements.markerButton.addTarget(self, action: #selector(markerButtonTapped), for: .touchUpInside)
            contentView.addSubview(elements.markerButton)
            contentView.addSubview(elements.cellsInf)
            contentView.addSubview(elements.chevronIcon)
            NSLayoutConstraint.activate([
                elements.markerButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                elements.markerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width),
                elements.cellsInf.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                elements.cellsInf.leadingAnchor.constraint(equalTo: elements.markerButton.trailingAnchor, constant: 12 / Aligners.modelWidth * Aligners.width),
                elements.chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                elements.chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width)
            ])
        } else {return}
    }
    @objc private func markerButtonTapped() {
        delegate?.toDoItemIsCompleted(in: self)
    }
}

// MARK: - completed items
class CustomCompletedTableViewCell: UITableViewCell {
    // item
    let elements = ViewElementsForMainScreen()
    weak var delegate: CustomTableViewCellDelegate?
     var item: ToDoItem? {
        didSet {
            configureCell()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // Сбрасываем значения ячейки
        item = nil
        elements.markerButton.setImage(nil, for: .normal)
        elements.title.text = nil
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell() {
        guard let item = item else { return }
        if item.isCompleted {
            elements.markerButton.setImage(UIImage(named: "CompletedMarker"), for: .normal)
            elements.title.text = item.text
            let attributedString = NSAttributedString(string: item.text, attributes: [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel!,
                NSAttributedString.Key.font: UIFont.body!
            ])
            elements.title.attributedText = attributedString
            elements.markerButton.addTarget(self, action: #selector(markerButtonTapped), for: .touchUpInside)
            contentView.addSubview(elements.markerButton)
            contentView.addSubview(elements.title)
            contentView.addSubview(elements.chevronIcon)
            NSLayoutConstraint.activate([
                elements.markerButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                elements.markerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width),
                elements.title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                elements.title.leadingAnchor.constraint(equalTo: elements.markerButton.trailingAnchor, constant: 12 / Aligners.modelWidth * Aligners.width),
                elements.chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                elements.chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width)
            ])
        } else {return}
    }
    @objc private func markerButtonTapped() {
        delegate?.toDoItemIsPending(in: self)
    }
}

// MARK: - new item
class SpecialTableViewCell: UITableViewCell {
    let elements = ViewElementsForMainScreen()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         configureCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureCell() {
        contentView.addSubview(elements.newItemCell)
        NSLayoutConstraint.activate([
            elements.newItemCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            elements.newItemCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52 / Aligners.modelWidth * Aligners.width)
            ])
    }
}
// swiftlint:enable line_length
