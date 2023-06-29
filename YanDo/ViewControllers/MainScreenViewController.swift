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
    
    let contentView = UIView()
    
    var completedItemsCount = DataManager.shared.completedItems.count
    var showCompletedToDoItems = false
    var completedItems: [ToDoItem] = DataManager.shared.completedItems {
        didSet {
            completedItemsCount = completedItems.count
            elements.completedLabel.text = "Выполнено — \(completedItemsCount)"
        }
    }

    var pendingItems = DataManager.shared.pendingItems
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "PrimaryBack")
        
        viewSettings()
        
        updateTable()
        infPanelSettings()
        tableSettings()
        newItemButtonSettings()
    }
    
    
    // MARK: - objc methods
    
    @objc func showButtonTapped() {
        showCompletedToDoItems.toggle()
        
        completedItems = Array(fileCache.itemsCollection.values).filter { $0.isCompleted }
        pendingItems = Array(fileCache.itemsCollection.values).filter { !$0.isCompleted }
        sortItemsByCreationDate()
        
        if showCompletedToDoItems {
            elements.showButton.setTitle("Скрыть", for: .normal)
        } else {
            elements.showButton.setTitle("Показать", for: .normal)
        }
        elements.tableView.reloadData()
        
    }
    
    @objc func createNewItem() {
        let vc = TaskScreenViewController(toDoItem: nil)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
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
        sortItemsByCreationDate()
        elements.tableView.reloadData()
        
    }
    
    func sortItemsByCreationDate() {
        var allItems = completedItems + pendingItems
        allItems.sort{ $0.createdDate > $1.createdDate }
        
        // Разделите отсортированный массив на массивы completedItems и pendingItems
        completedItems = allItems.filter { $0.isCompleted }
        pendingItems = allItems.filter { !$0.isCompleted }
        
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
            navigationBar.backgroundColor = UIColor(named: "PrimaryBack")
        }
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func infPanelSettings() {
        contentView.addSubview(elements.informationView)
        
        let label = elements.completedLabel
        label.text = "Выполнено — \(completedItemsCount)"
        
        let button = elements.showButton
        button.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        
        let stack = elements.informationView
        view.addSubview(stack)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(elements.showButton)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8 / Aligners.modelHight * Aligners.height),
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ])
    }
    
    func tableSettings() {
        contentView.addSubview(elements.tableView)
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
            elements.tableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            elements.tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func newItemButtonSettings() {
        view.addSubview(elements.newItemButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createNewItem))
            elements.newItemButton.isUserInteractionEnabled = true
            elements.newItemButton.addGestureRecognizer(tapGesture)
            
        NSLayoutConstraint.activate([
            elements.newItemButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 166 / Aligners.modelWidth * Aligners.width),
            elements.newItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54 / Aligners.modelHight * Aligners.height)
            ])
    }
    
}
