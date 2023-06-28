//
//  ViewElementsForMainScreen.swift
//  YanDo
//
//  Created by Александра Маслова on 27.06.2023.
//

import UIKit


class ViewElementsForMainScreen {
    
    // control panel
    
    let informationView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.widthAnchor.constraint(equalToConstant: 311 / Aligners.modelWidth * Aligners.width).isActive = true
        return stack
    }()
    
    let completedLabel: UILabel = {
        let text = UILabel()
        text.text = "Выполнено — 0"
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
    
    
    // cells
    
    func createStachForCells() -> UIStackView{
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func createStachForInf() -> UIStackView{
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    // cells components
    
    func createMarkerButton(item: ToDoItem) -> UIButton {
        let image = UIImage()
        let button = UIButton()
        if item.importance == Importance.high { button.setImage(UIImage(named: "RedMarker"), for: .normal) }
        else { button.setImage(UIImage(named: "PendingMarker"), for: .normal) }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createItemLabel(item: ToDoItem) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        var icon = UIImageView()
        
        if item.importance != Importance.normal {
            if item.importance == Importance.high { icon.image = UIImage(named: "ImportanceHight")! }
            if item.importance == Importance.low { icon.image =  UIImage(named: "ImportanceLow")! }
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.widthAnchor.constraint(equalToConstant: 16 / Aligners.modelWidth * Aligners.width).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 16 / Aligners.modelHight * Aligners.height).isActive = true
        }
        
        let text = UILabel()
        text.text = item.text
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.textColor = UIColor(named: "PrimaryLabel")
        text.numberOfLines = 3
        text.lineBreakMode = .byTruncatingTail
        text.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(text)
        
        return stack
    }
    
    func createDeadLineLabel(item: ToDoItem) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        var icon = UIImageView(image: UIImage(named: "Deadline")!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 16 / Aligners.modelWidth * Aligners.width).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 16 / Aligners.modelHight * Aligners.height).isActive = true
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        let title = formatter.string(from: item.deadline!)
        
        let text = UILabel()
        text.text = title
        text.font = UIFont(name: "SFProText-Regular", size: 15)
        text.textColor = UIColor(named: "TertiaryLabel")
        text.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(text)
        
        return stack
    }
    
    func changeCellviewToCompleted(item: ToDoItem) -> UIStackView {
        var stack = createStachForCells()
        
        let image = UIImageView(image: UIImage(named: "CompletedMarker"))
        
        let text = UILabel()
        text.text = item.text
        let attributedString = NSAttributedString(string: item.text, attributes: [
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryLabel")!,
            NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17)!
        ])
        text.attributedText = attributedString
        text.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(text)
        
        return stack
    }
    
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
