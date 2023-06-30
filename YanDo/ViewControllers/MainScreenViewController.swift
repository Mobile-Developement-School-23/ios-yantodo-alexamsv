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
        view.backgroundColor = UIColor.primaryBack
        
        viewSettings()
        
        updateTable()
        infPanelSettings()
        tableSettings()
        newItemButtonSettings()
    }
    
    
    // MARK: - objc methods
    
    @objc func showButtonTapped() {
        showCompletedToDoItems.toggle()
        
        if showCompletedToDoItems {
            elements.showButton.setTitle("Скрыть", for: .normal)
        } else {
            elements.showButton.setTitle("Показать", for: .normal)
        }
       updateTable()
        
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
        completedItems.sort{ $0.createdDate > $1.createdDate }
        pendingItems.sort{ $0.createdDate > $1.createdDate }
        
        elements.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        
    }
    
    func viewSettings() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryLabel!]
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Мои дела"

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.layoutMargins.top = 44 / Aligners.modelHight * Aligners.height
            navigationBar.layoutMargins.left = 32 / Aligners.modelWidth * Aligners.width
            navigationBar.preservesSuperviewLayoutMargins = true
            navigationBar.backgroundColor = UIColor.primaryBack
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
        //contentView.addSubview(elements.informationView)
        
        let label = elements.completedLabel
        label.text = "Выполнено — \(completedItemsCount)"
        
        let button = elements.showButton
        button.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
       
        view.addSubview(elements.informationView)
        elements.informationView.addArrangedSubview(label)
        elements.informationView.addArrangedSubview(elements.showButton)
        
        NSLayoutConstraint.activate([
            elements.informationView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8 / Aligners.modelHight * Aligners.height),
            elements.informationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
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
            elements.tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 52 / Aligners.modelHight * Aligners.height),
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

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var correctAmount: Int
        
        if showCompletedToDoItems {
            correctAmount = pendingItems.count + completedItems.count
        } else {
            correctAmount = pendingItems.count
        }
        // Добавляем 1 для специальной ячейки внизу
        return correctAmount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        
        // Проверяем, является ли текущая ячейка последней
        if indexPath.row == lastRowIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialCell", for: indexPath) as! SpecialTableViewCell
            // Настройка специальной ячейки
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 16, height: 16)).cgPath
            cell.layer.mask = maskLayer
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = UIColor.secondaryBack
            
            return cell
        } else {
            if showCompletedToDoItems {
                var allItems = completedItems + pendingItems
                allItems.sort{ $0.createdDate > $1.createdDate }
                
                if indexPath.row < completedItems.count {
                    let toDoItem = completedItems[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCompletedCell", for: indexPath) as! CustomCompletedTableViewCell
                    
                    cell.item = toDoItem
                    cell.delegate = self
                    cell.backgroundColor = UIColor.secondaryBack
                    
                    return cell
                } else {
                    let toDoItem = pendingItems[indexPath.row - completedItems.count]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
                    
                    cell.item = toDoItem
                    cell.delegate = self
                    cell.backgroundColor = UIColor.secondaryBack
                    
                    return cell
                }
            } else {
                let toDoItem = pendingItems[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
                
                cell.item = toDoItem
                cell.delegate = self
                cell.backgroundColor = UIColor.secondaryBack
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1 // индекс спец ячейки
        var height: CGFloat = 56
        
        if indexPath.row != lastRowIndex {
            if showCompletedToDoItems {
                if indexPath.row < completedItems.count {
                    let toDoItem = completedItems[indexPath.row]
                    if toDoItem.text.count > 25 && toDoItem.text.count < 50 { height += 20 }
                    if toDoItem.text.count > 50 { height += 42 }
                    
                } else {
                    let toDoItem = pendingItems[indexPath.row - completedItems.count]
                    if toDoItem.deadline != nil { height += 10 }
                    if toDoItem.text.count > 25 && toDoItem.text.count < 50 { height += 20 }
                    if toDoItem.text.count > 50 { height += 42 }
                }
                
            } else {
                let toDoItem = pendingItems[indexPath.row]
                if toDoItem.deadline != nil { height += 10 }
                if toDoItem.text.count > 25 && toDoItem.text.count < 50 { height += 20 }
                if toDoItem.text.count > 50 { height += 42 }
            }
        }
        
        return height / Aligners.modelHight * Aligners.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        
        if indexPath.row == lastRowIndex {
            let vc = TaskScreenViewController(toDoItem: nil)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true, completion: nil)
        } else {
            let toDoItem: ToDoItem
            if showCompletedToDoItems {
                if indexPath.row < completedItems.count {
                    toDoItem = completedItems[indexPath.row]
                } else {
                    toDoItem = pendingItems[indexPath.row - completedItems.count]
                }
            } else {
                toDoItem = pendingItems[indexPath.row]
            }
            
            let vc = TaskScreenViewController(toDoItem: toDoItem)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row != tableView.numberOfRows(inSection: 0) - 1 else {
            return nil // Не показывать свайп влево на последней ячейке
        }
        
        let toDoItem: ToDoItem
        if showCompletedToDoItems {
            if indexPath.row < completedItems.count {
                toDoItem = completedItems[indexPath.row]
            } else {
                toDoItem = pendingItems[indexPath.row - completedItems.count]
            }
        } else {
            toDoItem = pendingItems[indexPath.row]
        }
        
        // Действие свайпа влево
        let completedAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            let indexPathForCell = IndexPath(row: indexPath.row, section: indexPath.section)
            if toDoItem.isCompleted {
                if let cell = tableView.cellForRow(at: indexPathForCell) as? CustomCompletedTableViewCell {
                    self.toDoItemIsPending(in: cell)
                }
            } else {
                if let cell = tableView.cellForRow(at: indexPathForCell) as? CustomTableViewCell {
                    self.toDoItemIsCompleted(in: cell)
                }
            }
            
            completion(true)
        }
        
        if toDoItem.isCompleted {
            completedAction.image = UIImage(systemName: "arrow.turn.left.down")
            completedAction.backgroundColor = UIColor.grayLightColor
        } else {
            completedAction.image = UIImage(named: "Complete")
            completedAction.backgroundColor = UIColor.greenColor
        }
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [completedAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false // Отключение действия на полный свайп
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row != tableView.numberOfRows(inSection: 0) - 1 else {
            return nil
        }
        
        // красная иконка
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            // обрабатываем удаление через модель
            let toDoItem: ToDoItem
            if self.showCompletedToDoItems {
                if indexPath.row < self.completedItems.count {
                    toDoItem = self.completedItems[indexPath.row]
                } else {
                    toDoItem = self.pendingItems[indexPath.row - self.completedItems.count]
                }
            } else {
                toDoItem = self.pendingItems[indexPath.row]
            }
            
            self.fileCache.deleteToDoItem(itemsID: toDoItem.id)
            
            do {
                try self.fileCache.saveJsonToDoItemInFile(file: self.fileName)
            } catch {
                print(FileCacheErrors.failedToExtractData)
            }
            
            // анимация
            tableView.performBatchUpdates({
                if self.showCompletedToDoItems {
                    if indexPath.row < self.completedItems.count {
                        self.completedItems.remove(at: indexPath.row)
                    } else {
                        self.pendingItems.remove(at: indexPath.row - self.completedItems.count)
                    }
                } else {
                    self.pendingItems.remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: nil)
            
            completion(true)
        }
        
        deleteAction.image = UIImage(named: "Delete")
        deleteAction.backgroundColor = UIColor.redColor
        
        // серая иконка
        let showAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            let toDoItem: ToDoItem
            if self.showCompletedToDoItems {
                if indexPath.row < self.completedItems.count {
                    toDoItem = self.completedItems[indexPath.row]
                } else {
                    toDoItem = self.pendingItems[indexPath.row - self.completedItems.count]
                }
            } else {
                toDoItem = self.pendingItems[indexPath.row]
            }
            
            let vc = TaskScreenViewController(toDoItem: toDoItem)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            self.present(navVC, animated: true, completion: nil)
            
            completion(true)
        }
        
        showAction.image = UIImage(named: "Show")
        showAction.backgroundColor = UIColor.grayLightColor
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, showAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        
        return swipeConfiguration
    }

}

// Расширение для измениния состояния с ожидающего на выполненной и обратно
extension MainScreenViewController: CustomTableViewCellDelegate {
    //пометить item как выполненый
    func toDoItemIsCompleted(in cell: CustomTableViewCell) {
        // получаем item
        if let indexPath = elements.tableView.indexPath(for: cell) {
            var item: ToDoItem
            if !showCompletedToDoItems {
                 item = pendingItems[indexPath.row]
            } else {
                 item = pendingItems[indexPath.row - completedItems.count]
            }
            
            // перезаписываем item
            let newCompletedToDoItem = ToDoItem(text: item.text, importance: item.importance, deadline: item.deadline, isCompleted: true, createdDate: item.createdDate, dateОfСhange: item.dateОfСhange)
            fileCache.deleteToDoItem(itemsID: item.id)
            fileCache.addNewToDoItem(newCompletedToDoItem)
            do {
                try fileCache.saveJsonToDoItemInFile(file: fileName)
            } catch {
                print(FileCacheErrors.failedToExtractData)
            }
        }
        // обнавляем таблицу
        updateTable()
       
    }
    
    //пометить item как ожидающий
    func toDoItemIsPending(in cell: CustomCompletedTableViewCell) {
        // получаем item
        if let indexPath = elements.tableView.indexPath(for: cell) {
            let item = completedItems[indexPath.row]
            
            // перезаписываем item
            let newCompletedToDoItem = ToDoItem(text: item.text, importance: item.importance, deadline: item.deadline, isCompleted: false, createdDate: item.createdDate, dateОfСhange: item.dateОfСhange)
            fileCache.deleteToDoItem(itemsID: item.id)
            fileCache.addNewToDoItem(newCompletedToDoItem)
            do {
                try fileCache.saveJsonToDoItemInFile(file: fileName)
            } catch {
                print(FileCacheErrors.failedToExtractData)
            }
        }
        // обнавляем таблицу
       updateTable()
        
    }
    
}
