//
//  TaskScreenExtension.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 22.06.2023.
//

import UIKit


extension TaskScreenViewController: UITextViewDelegate {
    
    func updateScrollViewContentSize(by height: Double) {
        let contentHeight = contentView.subviews.reduce(0) { maxHeight, view in
            let viewMaxY = view.frame.maxY
            return max(maxHeight, viewMaxY)
        }
        let finalContentSize = CGSize(width: contentView.frame.width, height: contentHeight + height)
        contentView.contentSize = finalContentSize
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateScrollViewContentSize(by: settingsZoneHeight)
        // обновление вида
        if textView.text.isEmpty {
            componentsOff()
        }
        else {
            componentsOn()
            scrollToVisible()
        }
    }
    
    private func scrollToVisible() {
        let contentHeight = contentView.contentSize.height
        let visibleHeight = contentView.bounds.height
        
        // Прокрутка до видимой области
        if contentHeight > visibleHeight {
            let rect = CGRect(x: 0, y: contentHeight - visibleHeight, width: 1, height: visibleHeight)
            contentView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    
    func componentsOff() {
        elements.placeholder.isHidden = false
        
        rightNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryLabel")!, NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17)!], for: .normal)
        
        elements.deleteButton.setTitleColor(UIColor(named: "TertiaryLabel"), for: .normal)
        elements.deleteButton.removeTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        rightNavButton.isEnabled = false
    }
    
    func componentsOn() {
        elements.placeholder.isHidden = true
        
        rightNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "BlueColor")!, NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17)!], for: .normal)
        
        elements.deleteButton.setTitleColor(UIColor(named: "RedColor"), for: .normal)
        elements.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        rightNavButton.isEnabled = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.updateContainerHeightForCurrentOrientation()
        }, completion: nil)
    }

    private func updateContainerHeightForCurrentOrientation() {
        let container = elements.textFieldContainer
        
        if UIDevice.current.orientation.isLandscape {
            // Высота контейнера в горизонтальной ориентации
            container.constraints.filter { $0.firstAttribute == .height }.first?.constant = 300 / Aligners.modelHight * Aligners.height
        } else {
            // Высота контейнера в вертикальной ориентации
            container.constraints.filter { $0.firstAttribute == .height }.first?.constant = 120 / Aligners.modelHight * Aligners.height
        }
    }
}
