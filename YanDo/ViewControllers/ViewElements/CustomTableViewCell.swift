//
//  CustomTableViewCell.swift
//  YanDo
//
//  Created by Александра Маслова on 28.06.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    //item
    
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
    
    // cells components
    
    private let markerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PendingMarker"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 24 / Aligners.modelHight * Aligners.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24 / Aligners.modelWidth * Aligners.width).isActive = true
        return button
    }()
    
    private let cellsLabel: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let cellsInf: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let importanceIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "ImportanceHight")
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 10 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 16 / Aligners.modelHight * Aligners.height).isActive = true
        return icon
    }()
    
    private let title: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.textColor = UIColor(named: "PrimaryLabel")
        text.numberOfLines = 3
        text.lineBreakMode = .byTruncatingTail
        text.widthAnchor.constraint(equalToConstant: 250 / Aligners.modelWidth * Aligners.width).isActive = true
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    private let deadlineView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(named: "Deadline")!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 16 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 16 / Aligners.modelHight * Aligners.height).isActive = true
        
        stack.addArrangedSubview(icon)
        return stack
    }()
    
    private let deadlineTitle: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "SFProText-Regular", size: 15)
        text.textColor = UIColor(named: "TertiaryLabel")
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let chevronIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Chevron")
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 7 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 12 / Aligners.modelHight * Aligners.height).isActive = true
        return icon
    }()
    
    
    
    //cells settings
    
    private func configureCell() {
        guard let item = item else { return }
        
        var space: CGFloat = 16
        
        if !item.isCompleted {
        if item.importance == .high {
            markerButton.setImage(UIImage(named: "RedMarker"), for: .normal)
            cellsInf.addArrangedSubview(importanceIcon)
        }
        
        title.text = item.text
        cellsLabel.addArrangedSubview(title)
        
        if let deadline = item.deadline {
            space = 12
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM"
            let formattedDeadline = formatter.string(from: deadline)
            
            deadlineTitle.text = formattedDeadline
            deadlineView.addArrangedSubview(deadlineTitle)
            cellsLabel.addArrangedSubview(deadlineView)
        }
        
        cellsInf.addArrangedSubview(cellsLabel)
        
        contentView.addSubview(markerButton)
        contentView.addSubview(cellsInf)
            NSLayoutConstraint.activate([
                cellsInf.topAnchor.constraint(equalTo: contentView.topAnchor, constant: space / Aligners.modelHight * Aligners.height),
                cellsInf.leadingAnchor.constraint(equalTo: markerButton.trailingAnchor, constant: 12 / Aligners.modelWidth * Aligners.width),
                cellsInf.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -space / Aligners.modelHight * Aligners.height)
                ])
                
        } else {
            markerButton.setImage(UIImage(named: "CompletedMarker"), for: .normal)
            title.text = item.text
            
            let attributedString = NSAttributedString(string: item.text, attributes: [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryLabel")!,
                NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17)!
            ])
            title.attributedText = attributedString
            
            contentView.addSubview(markerButton)
            contentView.addSubview(title)
            
            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: space / Aligners.modelHight * Aligners.height),
                title.leadingAnchor.constraint(equalTo: markerButton.trailingAnchor, constant: 12 / Aligners.modelWidth * Aligners.width),
                title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -space / Aligners.modelHight * Aligners.height)
                ])
        }
        
        contentView.addSubview(chevronIcon)
        
        NSLayoutConstraint.activate([
            markerButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16 / Aligners.modelHight * Aligners.height),
            markerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width),
            markerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16 / Aligners.modelHight * Aligners.height),
            
            chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width)
        ])
        
    }
  
}

class SpecialTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let title: UILabel = {
        let text = UILabel()
        text.text = "Новое"
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.textColor = UIColor(named: "TertiaryLabel")
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    private func configureCell() {
        
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52 / Aligners.modelWidth * Aligners.width)
            ])
    }
    
}
