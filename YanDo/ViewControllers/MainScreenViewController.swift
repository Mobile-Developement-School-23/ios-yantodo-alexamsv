//
// MainScreenViewController.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 12.06.2023.
//

import UIKit
//здесь временно ставлю кнопку для отображения экрана задач (а именно последней задачи в списке)
class MainScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "PrimaryBack")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryLabel")!]
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Мои дела"

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.layoutMargins.left = 32
            navigationBar.preservesSuperviewLayoutMargins = true
        }
        
    }

    
}

