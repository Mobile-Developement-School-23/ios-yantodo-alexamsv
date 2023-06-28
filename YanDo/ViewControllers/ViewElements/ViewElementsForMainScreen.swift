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
        text.lineBreakMode = .byTruncatingTail
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
}
