//
// MainScreenViewController.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 12.06.2023.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    let fileCache = DataManager.shared.fileCache
    let fileName = DataManager.shared.fileName
    let elements = ViewElementsForMainScreen()
    
    var showCompletedToDoItems = false
    var completedItems = DataManager.shared.completedItems
    var pendingItems = DataManager.shared.pendingItems
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "PrimaryBack")
        
        viewSettings()
        
        updateTable()
        infPanelSettings()
        tableSettings()
    }
    
    
    // MARK: - objc methods
    
    @objc func showButtonTapped() {
        showCompletedToDoItems.toggle()
        
        completedItems = Array(fileCache.itemsCollection.values).filter { $0.isCompleted }
        pendingItems = Array(fileCache.itemsCollection.values).filter { !$0.isCompleted }
        
        if showCompletedToDoItems {
            elements.showButton.setTitle("Скрыть", for: .normal)
        } else {
            elements.showButton.setTitle("Показать", for: .normal)
        }
        elements.tableView.reloadData()
        
    }
    
    
    // MARK: - views settings
    
    func updateTable() {
        do {
           try fileCache.toDoItemsFromJsonFile(file: fileName)
        } catch {
            print(FileCacheErrors.failedToExtractData)
        }
        completedItems = Array(fileCache.itemsCollection.values).filter { $0.isCompleted }
        pendingItems = Array(fileCache.itemsCollection.values).filter { !$0.isCompleted }
        elements.tableView.reloadData()
    }

    
    func viewSettings() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryLabel")!]
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Мои дела"

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.layoutMargins.top = 44 / Aligners.modelHight * Aligners.height
            navigationBar.layoutMargins.left = 32 / Aligners.modelWidth * Aligners.width
            navigationBar.preservesSuperviewLayoutMargins = true
        }
    }
    
    func infPanelSettings() {
        view.addSubview(elements.informationView)
        
        let label = elements.completedLabel
        let completedItemsCount = fileCache.itemsCollection.values.filter { $0.isCompleted }.count
        label.text = "Выполнено — \(completedItemsCount)"
        
        let button = elements.showButton
        button.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        
        let stack = elements.informationView
        view.addSubview(stack)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(elements.showButton)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8 / Aligners.modelHight * Aligners.height),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
    }
    
    func tableSettings() {
        view.addSubview(elements.tableView)
        elements.tableView.delegate = self
        elements.tableView.dataSource = self
        
        elements.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        elements.tableView.register(CustomCompletedTableViewCell.self, forCellReuseIdentifier: "CustomCompletedCell")
        elements.tableView.register(SpecialTableViewCell.self, forCellReuseIdentifier: "SpecialCell")

        elements.tableView.isScrollEnabled = true
        elements.tableView.showsVerticalScrollIndicator = false
        
        elements.tableView.backgroundColor = .clear
        elements.tableView.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            elements.tableView.topAnchor.constraint(equalTo: elements.informationView.bottomAnchor, constant: 12 / Aligners.modelHight * Aligners.height),
            elements.tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            elements.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}
