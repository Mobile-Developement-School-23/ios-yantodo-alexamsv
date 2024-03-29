//
//  TaskScreenViewController.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 20.06.2023.
//
// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable file_length

import UIKit

class TaskScreenViewController: UIViewController, NetworkingService {
    private let toDoItem: ToDoItem?
    weak var delegate: MainScreenViewController?
    init(toDoItem: ToDoItem?) {
        self.toDoItem = toDoItem
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // networking
    let networkingService = DefaultNetworkingService()
    var itemsFromNet = NetworkingManager.shared.toDoItemsFromNet
    var indicator = NetworkingManager.shared.isDirty
    // model
    let fileCache = DataManager.shared.fileCache
    var completedItems = DataManager.shared.completedItems
    var pendingItems = DataManager.shared.pendingItems
    var correctId = ""
    // params
    private var importanceLevel = Importance.basic
    private var deadlineDate: Date?
    private var timing: Date?
    private let ind = ViewElementsForTaskScreen.cellsCount - 1
    // view
    let contentView = UIScrollView()
    let elements = ViewElementsForTaskScreen()
    var settingsZoneHeight = 148 / Aligners.modelHight * Aligners.height
    let leftNavButton = UIBarButtonItem(title: Text.cancel)
    let rightNavButton = UIBarButtonItem(title: Text.save)
    let toggle = UISwitch()

    private var showCalendarLabel = false
    private var showCalendarView = false
    private var showNotification = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.primaryBack
        viewSettings()
        navBarSettings()
        textPanelSettings()
        controlPanelSettings()
        deletePanelSettings()
        loadItem()
    }
    // MARK: - objc methods
    // keyboard
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
    // navigation
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    @objc func saveButtonTapped() {
        if let date = deadlineDate, let time = timing, let item = toDoItem {
                    cancelNotification(identifier: item.id)
                    scheduleNotification(date: date, time: time, text: elements.textView.text, identifier: item.id)
        }
        // добавляю локально
        if !elements.textView.text.isEmpty {
            if let item = toDoItem {
                let newItem = ToDoItem(id: item.id, text: elements.textView.text, importance: importanceLevel, deadline: deadlineDate, timing: timing, isCompleted: false, createdDate: Date(), dateОfСhange: nil)
                // добавляю в бд
                fileCache.updateItemInDatabases(id: item.id, item: newItem)
                // добавляю в сеть
                networkingService.updateToDoItemFromNet(id: newItem.id, item: newItem) { success in
                    if success {
                        self.indicator = false
                    } else { self.indicator = true }
                }
            } else {
                let newItem = ToDoItem( text: elements.textView.text, importance: importanceLevel, deadline: deadlineDate, timing: timing, isCompleted: false, createdDate: Date(), dateОfСhange: nil)
                // добавляю в бд
                fileCache.addItemToDatabases(item: newItem)
                // добавляю в сеть
                networkingService.addNewToDoItemToNet(item: newItem) { success in
                    if success {
                        self.indicator = false
                    } else { self.indicator = true }
                }
            }
            }
        delegate?.updateTable()
        cancelButtonTapped()
            // обновляю данные
        networkingService.updateListFromNet { success in
            if success {
                self.indicator = false
                DispatchQueue.main.async {
                    for item in self.networkingService.netToDoItems {
                        self.itemsFromNet.append(item)
                    }
                }
            } else { self.indicator = true }
        }
    }
    // importance
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: importanceLevel = Importance.low
        case 1: importanceLevel = Importance.basic
        case 2: importanceLevel = Importance.important
        default: break
        }
    }
    // deadline
    @objc func dateManager() {
        showCalendarLabel.toggle()
        let VStack = UIStackView()
        VStack.axis = .vertical
        VStack.alignment = .leading
        VStack.addArrangedSubview(elements.labels[ind])
        let HStask = elements.horizontalStacksForDate
        HStask.addArrangedSubview(elements.calendarButton)
        HStask.addArrangedSubview(elements.slash)
        HStask.addArrangedSubview(elements.timerButton)
        VStack.addArrangedSubview(HStask)

        elements.calendarButton.addTarget(self, action: #selector(calendarManager), for: .touchUpInside)
        elements.timerButton.addTarget(self, action: #selector(timerManager), for: .touchUpInside)
        if showCalendarLabel {
            // добавляем стэк на место label
            elements.horizontalStacksForCells[ind].removeArrangedSubview(elements.labels[ind])
            elements.horizontalStacksForCells[ind].insertArrangedSubview(VStack, at: 0)
            // Устанавливаем дату завтрашнего дня в переменную deadlineDate
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.day = 1
            let nextDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            deadlineDate = nextDate
        } else {
            // Устанавливаем значение nil и возвращаем прежнее состояние
            showCalendarView = true
            calendarManager()
            showNotification = true
            timerManager()
            deadlineDate = nil
            timing = nil
            elements.timerButton.setTitle(Text.remind, for: .normal)
            elements.timerButton.setTitleColor(.grayLightColor, for: .normal)
            elements.horizontalStacksForCells[ind].removeArrangedSubview(VStack)
            elements.horizontalStacksForCells[ind].insertArrangedSubview(self.elements.labels[ind], at: 0)
        }
    }
    @objc func calendarManager() {
        showCalendarView.toggle()
        if showCalendarView {
            showNotification = true
            timerManager()
            updateScrollViewContentSize(by: settingsZoneHeight + elements.calendar.frame.height)
            hideKeyBoard()
            elements.verticalStackView.addArrangedSubview(elements.dividers[ind])
            elements.verticalStackView.addArrangedSubview(elements.calendar)
            elements.calendar.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            // Анимация для календаря
            elements.calendar.alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.elements.calendar.alpha = 1.0
            }, completion: nil)
        } else {
            cancelNotification(identifier: correctId)
            updateScrollViewContentSize(by: settingsZoneHeight - elements.calendar.frame.height)
            // удаление элементов с анимацией
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.elements.calendar.alpha = 0.0
            }, completion: { _ in
                self.elements.calendar.removeFromSuperview()
                self.elements.dividers[self.ind].removeFromSuperview()
            })
        }
        UIView.transition(with: view, duration: 0.5, options: .layoutSubviews, animations: {
            self.elements.calendar.alpha = self.showCalendarLabel ? 1.0 : 0.0
        }, completion: nil)
    }
    @objc func timerManager() {
        showNotification.toggle()
        if showNotification {
            showCalendarView = true
            calendarManager()
            updateScrollViewContentSize(by: settingsZoneHeight + elements.timer.frame.height)
            hideKeyBoard()
            elements.verticalStackView.addArrangedSubview(elements.dividers[ind])
            elements.verticalStackView.addArrangedSubview(elements.timer)
            elements.timer.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
            // Анимация для таймера
            elements.timer.alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.elements.timer.alpha = 1.0
            }, completion: nil)
        } else {
            updateScrollViewContentSize(by: settingsZoneHeight - elements.timer.frame.height)
            // удаление элементов с анимацией
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.elements.timer.alpha = 0.0
            }, completion: { _ in
                self.elements.timer.removeFromSuperview()
                self.elements.dividers[self.ind].removeFromSuperview()
            })
        }
        UIView.transition(with: view, duration: 0.5, options: .layoutSubviews, animations: {
            self.elements.timer.alpha = self.showCalendarLabel ? 1.0 : 0.0
        }, completion: nil)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectDate(date: sender.date)
    }
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        elements.timerButton.setTitleColor(.blueColor, for: .normal)
        selectTime(time: sender.date)
    }
    // delete
    @objc func deleteButtonTapped() {
        // удаляю из бд
        fileCache.deleteItemFromDatabases(id: correctId)
        delegate?.updateTable()
        // удаляю из сети
        networkingService.deleteToDoItemFromNet(id: correctId) { success in
            if success {
                self.indicator = false
            } else { self.indicator = true }
        }
        pendingItems = pendingItems.filter { $0.id != correctId }
        completedItems = completedItems.filter { $0.id != correctId }
        itemsFromNet = itemsFromNet.filter { $0.id != correctId }
        // удаляю уведомление
        cancelNotification(identifier: correctId)
        // выхожу
        delegate?.updateTable()
        cancelButtonTapped()
    }
    // MARK: - views settings
    func viewSettings() {
        contentView.showsVerticalScrollIndicator = false
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func navBarSettings() {
        // Заголовок
        navigationItem.title = Text.toDo
        let font = UIFont.headline
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.primaryBack!,
            .font: font!
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        // Отменить
        leftNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blueColor!, NSAttributedString.Key.font: UIFont.body!], for: .normal)
        leftNavButton.target = self
        leftNavButton.action = #selector(cancelButtonTapped)
        navigationItem.leftBarButtonItem = leftNavButton
        // Сохранить
        rightNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel!, NSAttributedString.Key.font: UIFont.body!], for: .normal)
        rightNavButton.target = self
        rightNavButton.action = #selector(saveButtonTapped)
        rightNavButton.isEnabled = false
        navigationItem.rightBarButtonItem = rightNavButton
    }
    func loadItem() {
        if let item = toDoItem {
            // изменение вида
            elements.placeholder.isHidden = true
            componentsOn()
            // достаем нужные значения
            correctId = item.id
            importanceLevel = item.importance
            elements.textView.text = item.text
            let lines = item.text.components(separatedBy: "\n").count
            // еще изменение вида (высота предстваления)
            let size = settingsZoneHeight + Double(CGFloat(lines * 22) / Aligners.modelHight * Aligners.height)
            // продолжаем достовать значения
            let index: Int = {
                var ind = 1
                if item.importance == .low { ind = 0 }
                if item.importance == .important { ind = 2 }
                return ind
            }()
            elements.segmentedControl.selectedSegmentIndex = index
            if let date = item.deadline {
                toggle.setOn(true, animated: true)
                dateManager()
                elements.calendar.setDate(date, animated: true)
                selectDate(date: date)
                if let time = item.timing {
                    elements.timer.setDate(time, animated: true)
                    elements.timerButton.setTitleColor(.blueColor, for: .normal)
                    selectTime(time: time)
                }
            }
            updateScrollViewContentSize(by: size)
        }
    }
    func textPanelSettings() {
        let container = elements.textFieldContainer
        contentView.addSubview(container)
        container.addSubview(elements.textView)
        container.addSubview(elements.placeholder)
        elements.textView.delegate = self
        elements.textView.isScrollEnabled = true
        container.heightAnchor.constraint(greaterThanOrEqualToConstant: 120 / Aligners.modelHight * Aligners.height).isActive = true
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16 / Aligners.modelHight * Aligners.height),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width),
            elements.placeholder.topAnchor.constraint(equalTo: container.topAnchor, constant: 17 / Aligners.modelHight * Aligners.height),
            elements.placeholder.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16 / Aligners.modelWidth * Aligners.width),
            elements.textView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width),
            elements.textView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width),
            elements.textView.topAnchor.constraint(equalTo: container.topAnchor, constant: 17 / Aligners.modelHight * Aligners.height),
            elements.textView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -17 / Aligners.modelHight * Aligners.height)
        ])
        // keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Text.done, style: .done, target: self, action: #selector(hideKeyBoard))
        toolbar.items = [flexibleSpace, doneButton]
        elements.textView.delegate = self
        elements.textView.inputAccessoryView = toolbar
        elements.textView.isScrollEnabled = false
    }
    func controlPanelSettings() {
        // располагаем основной вертикальный стэк в горизонтальный стэк, в который помещаем пустые view - отступы.
        let HStack = elements.horizontalStackView
        let VStack = elements.verticalStackView
        contentView.addSubview(HStack)
        HStack.addArrangedSubview(elements.leadingSpacer)
        HStack.addArrangedSubview(VStack)
        HStack.addArrangedSubview(elements.trailingSpacer)
        NSLayoutConstraint.activate([
            HStack.topAnchor.constraint(equalTo: elements.textFieldContainer.bottomAnchor, constant: 16 / Aligners.modelHight * Aligners.height),
            HStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width ),
            HStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width)
        ])
        // коллекция view для правой части ячеек
        var actors = [UIView]()
        // настройка элементов коллекции
        let segmentedCtrl = elements.segmentedControl
        segmentedCtrl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        toggle.addTarget(self, action: #selector(dateManager), for: .valueChanged)
        actors.append(segmentedCtrl)
        actors.append(toggle)
        // создание ячеек
        for ind in 0..<actors.count {
            let hStack = elements.horizontalStacksForCells[ind]
            // добавляем элементы
            let label = elements.labels[ind]
            hStack.addArrangedSubview(label)
            let actor = actors[ind]
            hStack.addArrangedSubview(actor)
            // добавляем HStack-ячейку в основной VStack
            VStack.addArrangedSubview(hStack)
            // добавляем разделитель в основной VStack
            if ind < elements.dividers.count - 1 { VStack.addArrangedSubview(elements.dividers[ind]) }
        }
    }
    func selectDate(date: Date) {
        deadlineDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        var nextDateFormatted = dateFormatter.string(from: date)
        if nextDateFormatted.hasPrefix("0") {nextDateFormatted.removeFirst()} // если число с 1 по 9 включительно
        elements.calendarButton.setTitle(nextDateFormatted, for: .normal)
    }
    func selectTime(time: Date) {
        timing = time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: time)
        elements.timerButton.setTitle(formattedTime, for: .normal)
    }

    func deletePanelSettings() {
        contentView.addSubview(elements.deleteButton)
        elements.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            elements.deleteButton.topAnchor.constraint(equalTo: elements.verticalStackView.bottomAnchor, constant: 16 / Aligners.modelHight * Aligners.height),
            elements.deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16 / Aligners.modelWidth * Aligners.width),
            elements.deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16 / Aligners.modelWidth * Aligners.width)
        ])
    }
}

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
        } else {
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
        rightNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel!, NSAttributedString.Key.font: UIFont.body!], for: .normal)
        elements.deleteButton.setTitleColor(UIColor.tertiaryLabel, for: .normal)
        elements.deleteButton.removeTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        rightNavButton.isEnabled = false
    }
    func componentsOn() {
        elements.placeholder.isHidden = true
        rightNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blueColor!, NSAttributedString.Key.font: UIFont.body!], for: .normal)
        elements.deleteButton.setTitleColor(UIColor.redColor, for: .normal)
        elements.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        rightNavButton.isEnabled = true
    }
}
// swiftlint:enable line_length
// swiftlint:enable type_body_length
// swiftlint:enable file_length
