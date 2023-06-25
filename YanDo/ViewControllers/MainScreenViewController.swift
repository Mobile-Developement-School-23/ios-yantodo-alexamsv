//
// MainScreenViewController.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 12.06.2023.
//

import UIKit
//здесь временно ставлю кнопку для отображения экрана задач (а именно последней задачи в списке)
class MainScreenViewController: UIViewController {
    
    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "PrimaryBack")
        view.addSubview(button)
        
        button.setTitle("show task screen", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 20)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = [
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraint)
        
    }
    
    @objc func buttonAction() {
        let vc = TaskScreenViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    
}

