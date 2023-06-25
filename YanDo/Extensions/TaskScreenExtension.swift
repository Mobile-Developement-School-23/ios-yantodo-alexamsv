//
//  TaskScreenExtension.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 22.06.2023.
//

import UIKit


extension TaskScreenViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            elements.placeholder.isHidden = false
            
            rightNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryLabel")!, NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17)!], for: .normal)
            
            elements.deleteButton.setTitleColor(UIColor(named: "TertiaryLabel"), for: .normal)
            elements.deleteButton.removeTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        }
        else {
            elements.placeholder.isHidden = true
            
            rightNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "BlueColor")!, NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17)!], for: .normal)
            
            elements.deleteButton.setTitleColor(UIColor(named: "RedColor"), for: .normal)
            elements.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        }
        
        // Обновление размера и оформления
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        elements.textFieldContainer.frame.size.height = size.height + (17 / Aligners.modelHight * Aligners.height) + (17 / Aligners.modelHight * Aligners.height)
        textView.frame.size.height = size.height
    }
    
}


