//
// MainScreenViewController.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 12.06.2023.
//
// swiftlint:disable force_cast
// swiftlint:disable line_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable unused_closure_parameter
import UIKit

class MainScreenViewController: UIViewController, NetworkingService {
    let fileCache = DataManager.shared.fileCache
    let fileName = DataManager.shared.fileName
    var pendingItems = DataManager.shared.pendingItems
    var completedItems: [ToDoItem] = DataManager.shared.completedItems {
        didSet {
            completedItemsCount = completedItems.count
            DispatchQueue.main.async {
                self.elements.completedLabel.text = "Выполнено — \(self.completedItemsCount)"
            }
        }
    }
    // networking
    let networkingService = DefaultNetworkingService()
    var itemsFromNet = NetworkingManager.shared.toDoItemsFromNet
    //view
    let elements = ViewElementsForMainScreen()
    let contentView = UIView()
    var completedItemsCount = DataManager.shared.completedItems.count
    var showCompletedToDoItems = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.primaryBack
        viewSettings()
        fileCache.toDoItemsFromJsonFile(file: fileName)
    
        infPanelSettings()
        tableSettings()
        newItemButtonSettings()

        networkStart()
        updateTable()

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
        let tvc = TaskScreenViewController(toDoItem: nil)
        tvc.delegate = self
        let navVC = UINavigationController(rootViewController: tvc)
        present(navVC, animated: true, completion: nil)
    }
    // MARK: - views settings
    func networkStart () {
        networkingService.getCorrectInfFromNet()
        networkingService.updateListFromNet { success in
            if success {
                DispatchQueue.main.async {
                    for item in self.networkingService.netToDoItems {
                        self.itemsFromNet.append(item)
                    }
                    self.updateTable()
                }
            } else {

            }
        }

    }
    func updateTable() {
        // Объединение массивов
        var combinedItems = Array(fileCache.itemsCollection.values) + itemsFromNet
        if NetworkingManager.shared.isDirty {
             combinedItems = itemsFromNet + Array(fileCache.itemsCollection.values)
        }

        // Удаление дублирующихся элементов на основе id
        var uniqueItems = [ToDoItem]()
        var encounteredIDs = Set<String>()

        for item in combinedItems {
            if !encounteredIDs.contains(item.id) {
                uniqueItems.append(item)
                encounteredIDs.insert(item.id)
            }
        }

        // Фильтрация уникальных элементов по isCompleted
         completedItems = uniqueItems.filter { $0.isCompleted }
         pendingItems = uniqueItems.filter { !$0.isCompleted }

        // Сортировка массивов
        completedItems.sort { $0.createdDate > $1.createdDate }
        pendingItems.sort { $0.createdDate > $1.createdDate }

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
// contentView.addSubview(elements.informationView)
        let label = elements.completedLabel
        label.text = "Выполнено — \(completedItemsCount)"
        let button = elements.showButton
        button.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        view.addSubview(elements.informationView)
        elements.informationView.addArrangedSubview(label)
        elements.informationView.addArrangedSubview(elements.showButton)
        NSLayoutConstraint.activate([
            elements.informationView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8 / Aligners.modelHight * Aligners.height),
            elements.informationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
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
                allItems.sort { $0.createdDate > $1.createdDate }
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
            let tvc = TaskScreenViewController(toDoItem: nil)
            tvc.delegate = self
            let navVC = UINavigationController(rootViewController: tvc)
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
            let tvc = TaskScreenViewController(toDoItem: toDoItem)
            tvc.delegate = self
            let navVC = UINavigationController(rootViewController: tvc)
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
            self.fileCache.saveJsonToDoItemInFile(file: self.fileName)
            // удаляем из сети
            networkingService.deleteToDoItemFromNet(id: toDoItem.id) { success in
                if success {
                    DispatchQueue.main.async {
                        self.pendingItems = self.pendingItems.filter { $0.id != toDoItem.id }
                        self.completedItems = self.completedItems.filter { $0.id != toDoItem.id }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.pendingItems = self.pendingItems.filter { $0.id != toDoItem.id }
                        self.completedItems = self.completedItems.filter { $0.id != toDoItem.id }
                    }
                
                }
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
            let tvc = TaskScreenViewController(toDoItem: toDoItem)
            tvc.delegate = self
            let navVC = UINavigationController(rootViewController: tvc)
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
    // пометить item как выполненый
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
            let newCompletedToDoItem = ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, isCompleted: true, createdDate: item.createdDate, dateОfСhange: item.dateОfСhange)
            fileCache.deleteToDoItem(itemsID: item.id)
            fileCache.addNewToDoItem(newCompletedToDoItem)
            fileCache.saveJsonToDoItemInFile(file: fileName)
            // изменяем в сети
            networkingService.updateToDoItemFromNet(id: newCompletedToDoItem.id, item: newCompletedToDoItem) { success in
                if success {
        
                } else {
    
                }
            }
    
            networkingService.updateListFromNet { success in
                if success {
                    DispatchQueue.main.async {
                        for item in self.networkingService.netToDoItems {
                            self.itemsFromNet.append(item)
                        }
                        self.updateTable()
                    }
                } else { }
            }

        }
    }
    // пометить item как ожидающий
    func toDoItemIsPending(in cell: CustomCompletedTableViewCell) {
        // получаем item
        if let indexPath = elements.tableView.indexPath(for: cell) {
            let item = completedItems[indexPath.row]
            // перезаписываем item
            let newPendingToDoItem = ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, isCompleted: false, createdDate: item.createdDate, dateОfСhange: item.dateОfСhange)
            fileCache.deleteToDoItem(itemsID: item.id)
            fileCache.addNewToDoItem(newPendingToDoItem)
            fileCache.saveJsonToDoItemInFile(file: fileName)
            // изменяем в сети
            networkingService.updateToDoItemFromNet(id: newPendingToDoItem.id, item: newPendingToDoItem) { success in
                if success {
                
                } else {
            
                }
            }

            networkingService.updateListFromNet() { success in
                if success {
                    DispatchQueue.main.async {
                        for item in self.networkingService.netToDoItems {
                            self.itemsFromNet.append(item)
                        }
                        self.updateTable()
                    }
                } else {
                
                }
            }
        }
    }
}
// swiftlint:enable force_cast
// swiftlint:enable line_length
// swiftlint:enable cyclomatic_complexity
// swiftlint:enable function_body_length
// swiftlint:enable unused_closure_parameter
