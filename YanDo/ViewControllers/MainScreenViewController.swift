//
// MainScreenViewController.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 12.06.2023.
//
// swiftlint:disable force_cast
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable unused_closure_parameter
// swiftlint:disable empty_parentheses_with_trailing_closure
// swiftlint:disable for_where
// swiftlint:disable file_length
import UIKit

class MainScreenViewController: UIViewController, NetworkingService {
    let sql = DataManager.shared.sql
    let coredata = DataManager.shared.coredata
    var pendingItems = DataManager.shared.pendingItems
    var completedItems: [ToDoItem] = DataManager.shared.completedItems {
        didSet {
            completedItemsCount = completedItems.count
            DispatchQueue.main.async {
                self.headerView.completedLabel.text = Text.doneCounter + String(self.completedItemsCount)
            }
        }
    }
    // networking
    let networkingService = DefaultNetworkingService()
    var itemsFromNet = NetworkingManager.shared.toDoItemsFromNet
    var indicator: Bool = NetworkingManager.shared.isDirty {
        didSet {
            if indicator {
                headerView.netIndicator.image = SystemImages.disconnect.uiImage
            } else {
                headerView.netIndicator.image = SystemImages.connect.uiImage
            }
        }
    }

    // view
    let elements = ViewElementsForMainScreen()
    let headerView = CustomTableViewHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 50 / Aligners.modelHight * Aligners.height))
    var completedItemsCount = DataManager.shared.completedItems.count
    var showCompletedToDoItems = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.primaryBack
        self.view.tintColor = UIColor.blueColor

        viewSettings()

        sql.toDoItemsFromSQLdatabase()
        coredata.toDoItemsFromCoreDatabase()

        infPanelSettings()
        tableSettings()
        newItemButtonSettings()
        updateTable()

        networkStart()
        updateTable()
    }
    // MARK: - objc methods
    @objc func showButtonTapped(button: UIButton) {
        showCompletedToDoItems.toggle()
        if showCompletedToDoItems {
            button.setTitle(Text.hide, for: .normal)
        } else {
            button.setTitle(Text.show, for: .normal)
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
    @objc func networkStart () {
        networkingService.getCorrectInfFromNet { isSuccess in
            if isSuccess {
                self.networkingService.updateListFromNet { [self] success in
                    if success {
                        indicator = false
                        DispatchQueue.main.async { [self] in
                            for item in networkingService.netToDoItems {
                                itemsFromNet.append(item)
                            }
                            updateTable()
                        }
                    } else { indicator = true }
                }
            } else { return }
        }
    }
    func updateTable() {
        // Объединение массивов
        let combinedItems = coredata.itemsCollection + sql.itemsCollection + itemsFromNet
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
        navigationItem.title = Text.title

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.layoutMargins.top = 44 / Aligners.modelHight * Aligners.height
            navigationBar.layoutMargins.left = 32 / Aligners.modelWidth * Aligners.width
            navigationBar.preservesSuperviewLayoutMargins = true
        }
    }

    func infPanelSettings() {
        headerView.netIndicator.image = SystemImages.disconnect.uiImage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(networkStart))
        headerView.netIndicator.isUserInteractionEnabled = true
        headerView.netIndicator.addGestureRecognizer(tapGesture)
        headerView.completedLabel.text =  Text.doneCounter + String(completedItemsCount)
        headerView.showButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
    }
    func tableSettings() {
        view.addSubview(elements.tableView)
        elements.tableView.delegate = self
        elements.tableView.dataSource = self
        elements.tableView.tableHeaderView = headerView
        elements.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        elements.tableView.register(CustomCompletedTableViewCell.self, forCellReuseIdentifier: "CustomCompletedCell")
        elements.tableView.register(SpecialTableViewCell.self, forCellReuseIdentifier: "SpecialCell")

        elements.tableView.showsVerticalScrollIndicator = false
        elements.tableView.backgroundColor = .clear
        elements.tableView.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
            elements.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            elements.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            elements.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width),
            elements.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width)
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
                    height += calculateHeight(forText: toDoItem.text)
                } else {
                    let toDoItem = pendingItems[indexPath.row - completedItems.count]
                    if toDoItem.deadline != nil { height += 10 }
                    height += calculateHeight(forText: toDoItem.text)
                }
            } else {
                let toDoItem = pendingItems[indexPath.row]
                if toDoItem.deadline != nil { height += 10 }
                height += calculateHeight(forText: toDoItem.text)
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
            completedAction.image = SystemImages.arrow.uiImage
            completedAction.backgroundColor = UIColor.grayLightColor
        } else {
            completedAction.image = Images.complete.uiImage
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
        // красная иконка
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            // обрабатываем удаление в бд
            self.sql.deleteItemFromSQLDatabase(id: toDoItem.id)
            self.coredata.deleteItemFromCoreDatabase(id: toDoItem.id)
            // удаляем уведомление
            cancelNotification(identifier: toDoItem.id)
            // удаляем из сети
            networkingService.deleteToDoItemFromNet(id: toDoItem.id) { success in
                if success {
                    self.indicator = false
                    DispatchQueue.main.async {
                        self.pendingItems = self.pendingItems.filter { $0.id != toDoItem.id }
                        self.completedItems = self.completedItems.filter { $0.id != toDoItem.id }
                        self.itemsFromNet = self.itemsFromNet.filter { $0.id != toDoItem.id }
                }
                } else {
                    self.indicator = true
                    DispatchQueue.main.async {
                        self.pendingItems = self.pendingItems.filter { $0.id != toDoItem.id }
                        self.completedItems = self.completedItems.filter { $0.id != toDoItem.id }
                        self.itemsFromNet = self.itemsFromNet.filter { $0.id != toDoItem.id }
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
        deleteAction.image = Images.delete.uiImage
        deleteAction.backgroundColor = UIColor.redColor
        // серая иконка
        let showAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else {
                completion(false)
                return
            }
        }
        var actions = [deleteAction]
        if !toDoItem.isCompleted { actions.append(showAction) }
        if let timing = toDoItem.timing {
            showAction.image = SystemImages.bell.uiImage
        } else { showAction.image = SystemImages.slashBell.uiImage }
        showAction.backgroundColor = UIColor.grayLightColor
        showAction.backgroundColor = UIColor.grayLightColor
        let swipeConfiguration = UISwipeActionsConfiguration(actions: actions)
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
            // удаляем уведомление
            cancelNotification(identifier: item.id)
            // перезаписываем item
            let newCompletedToDoItem = ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, timing: item.timing, isCompleted: true, createdDate: item.createdDate, dateОfСhange: item.dateОfСhange)
            sql.updateItemInSQLDatabase(id: item.id, item: newCompletedToDoItem)
            coredata.updateItemInCoreDataBase(id: item.id, item: newCompletedToDoItem)
            // изменяем в сети
            networkingService.updateToDoItemFromNet(id: newCompletedToDoItem.id, item: newCompletedToDoItem) { success in
                if success {
                    self.indicator = false
                } else {
                    DispatchQueue.main.async {
                        self.indicator = true
                        self.updateTable()
                    }
                }
            }
            networkingService.updateListFromNet { success in
                if success {
                    self.indicator = false
                    DispatchQueue.main.async {
                        for item in self.networkingService.netToDoItems {
                            self.itemsFromNet.append(item)
                            self.updateTable()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        for item in self.networkingService.netToDoItems {
                            self.itemsFromNet.append(item)
                            self.updateTable()
                        }
                    }
                    self.indicator = true
                }
            }
            updateTable()
        }
    }
    // пометить item как ожидающий
    func toDoItemIsPending(in cell: CustomCompletedTableViewCell) {
        // получаем item
        if let indexPath = elements.tableView.indexPath(for: cell) {
            let item = completedItems[indexPath.row]
            // включаем уведомление
            if let date = item.deadline {
                if let time = item.timing {
                    scheduleNotification(date: date, time: time, text: item.text, identifier: item.id)
                }
            }
            // перезаписываем item
            let newPendingToDoItem = ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, timing: item.timing, isCompleted: false, createdDate: item.createdDate, dateОfСhange: item.dateОfСhange)
            sql.updateItemInSQLDatabase(id: item.id, item: newPendingToDoItem)
            coredata.updateItemInCoreDataBase(id: item.id, item: newPendingToDoItem)
            // изменяем в сети
            networkingService.updateToDoItemFromNet(id: newPendingToDoItem.id, item: newPendingToDoItem) { success in
                if success {
                    self.indicator = false
                } else {
                    DispatchQueue.main.async {
                        self.updateTable()
                        self.indicator = true
                    }
                }
            }
            networkingService.updateListFromNet() { success in
                if success {
                    self.indicator = false
                    DispatchQueue.main.async {
                        for item in self.networkingService.netToDoItems {
                            self.itemsFromNet.append(item)
                            self.updateTable()
                        }
                    }
                } else {
                    self.indicator = true
                    DispatchQueue.main.async {
                        for item in self.networkingService.netToDoItems {
                            self.itemsFromNet.append(item)
                            self.updateTable()
                        }
                    }
                }
            }
            updateTable()
        }
    }
}
// swiftlint:enable force_cast
// swiftlint:enable line_length
// swiftlint:enable function_body_length
// swiftlint:enable unused_closure_parameter
// swiftlint:enable empty_parentheses_with_trailing_closure
// swiftlint:enable for_where
// swiftlint:enable file_length
