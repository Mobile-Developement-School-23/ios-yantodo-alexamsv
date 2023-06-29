//
//  ViewElementsForMainScreen.swift
//  YanDo
//
//  Created by Александра Маслова on 27.06.2023.
//

import UIKit


class ViewElementsForMainScreen {
    
    // inf panel
    
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
        text.font = UIFont(name: "SFProText-Regular", size: 15)
        text.textColor = UIColor(named: "TertiaryLabel")
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let showButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)
        button.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
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
        button.heightAnchor.constraint(equalToConstant: 24 / Aligners.modelHight * Aligners.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24 / Aligners.modelWidth * Aligners.width).isActive = true
        return button
    }()
    
     let cellsLabel: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let cellsInf: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let importanceIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 10 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 16 / Aligners.modelHight * Aligners.height).isActive = true
        return icon
    }()
    
     let title: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.textColor = UIColor(named: "PrimaryLabel")
        text.numberOfLines = 3
        text.lineBreakMode = .byTruncatingTail
        text.widthAnchor.constraint(equalToConstant: 250 / Aligners.modelWidth * Aligners.width).isActive = true
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    let deadlineView: UIStackView = {
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
    
    let deadlineTitle: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "SFProText-Regular", size: 15)
        text.textColor = UIColor(named: "TertiaryLabel")
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
    
    let newItemButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44 / Aligners.modelHight * Aligners.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44 / Aligners.modelWidth * Aligners.width).isActive = true
        return button
    }()
    
    let newItemCell: UILabel = {
        let text = UILabel()
        text.text = "Новое"
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.textColor = UIColor(named: "TertiaryLabel")
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
}
