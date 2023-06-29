//
//  TaskScreenViewController.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 20.06.2023.
//

import UIKit

class TaskScreenViewController: UIViewController {
    
    private let toDoItem: ToDoItem?
    weak var delegate: MainScreenViewController?
    
    init(toDoItem: ToDoItem?) {
        self.toDoItem = toDoItem
        super.init(nibName: nil, bundle: nil)
         }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let fileCache = DataManager.shared.fileCache
    let fileName = DataManager.shared.fileName
    var completedItems = DataManager.shared.completedItems
    var pendingItems = DataManager.shared.pendingItems
    var correctId = ""
    
    let contentView = UIScrollView()
    let elements = ViewElementsForTaskScreen()
    
    var settingsZoneHeight = 148 / Aligners.modelHight * Aligners.height
    
    let leftNavButton = UIBarButtonItem(title: "Отменить")
    let rightNavButton = UIBarButtonItem(title: "Сохранить")
    let toggle = UISwitch()
    
    private var showCalendarLabel = false
    private var showCalendarView = false
    
    private var importanceLevel = Importance.normal
    private var deadlineDate: Date?
    private let ind = ViewElementsForTaskScreen.cellsCount - 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "PrimaryBack")
                
        viewSettings()
        navBarSettings()
        textPanelSettings()
        controlPanelSettings()
        deletePanelSettings()
        
        loadItem()
    }
    
    // MARK: - objc methods
    
    //keyboard
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
    
     // navigation
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        // добавляю локально
        if !elements.textView.text.isEmpty {
            if let item = toDoItem { fileCache.deleteToDoItem(itemsID: item.id) }
            let item = ToDoItem(text: elements.textView.text, importance: importanceLevel, deadline: deadlineDate, isCompleted: false, createdDate: Date(), dateОfСhange: nil)
            
            fileCache.addNewToDoItem(item)
            //добавляю в файл
            do {
                try fileCache.saveJsonToDoItemInFile(file: fileName)
                delegate?.updateTable()
                cancelButtonTapped()
                
            } catch {
                print(FileCacheErrors.failedToExtractData)
                
            }
            cancelButtonTapped()
        }
        
    }
    
    // importance
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            
        case 0: importanceLevel = Importance.low
        case 1: importanceLevel = Importance.normal
        case 2: importanceLevel = Importance.high
            
        default: break
        }
    }
    
    // deadline
    
    @objc func dateManager() {
        showCalendarLabel.toggle()
        
        showCalendarView = false
        
        let VStack = UIStackView()
        VStack.axis = .vertical
        VStack.alignment = .leading
        
        VStack.addArrangedSubview(elements.labels[ind])
        VStack.addArrangedSubview(elements.calendarButton)
        elements.calendarButton.addTarget(self, action: #selector(calendarManager), for: .touchUpInside)

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
            // Устанавливаем значение nil в переменную deadlineDate и возвращаем прежнее состояние
            deadlineDate = nil
            elements.horizontalStacksForCells[ind].removeArrangedSubview(VStack)
            elements.horizontalStacksForCells[ind].insertArrangedSubview(self.elements.labels[ind], at: 0)
        }
        
    }
    
    @objc func calendarManager() {
        showCalendarView.toggle()
        
        if showCalendarView && showCalendarLabel {
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectDate(date: sender.date)
        calendarManager()
    }
    
    //delete

    @objc func deleteButtonTapped() {
         fileCache.deleteToDoItem(itemsID: correctId)
        
         // пересохраняю файл уже без элемента
        do {
            try fileCache.saveJsonToDoItemInFile(file: fileName)
            delegate?.updateTable()
            cancelButtonTapped()
            
        } catch {
            print(FileCacheErrors.failedToExtractData)
            
        }
         // выхожу
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
        navigationItem.title = "Дело"
        let font = UIFont(name: "SFProText-Semibold", size: 17)!
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "PrimaryLabel")!,
            .font: font
        ]
        
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        // Отменить
        leftNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "BlueColor")!, NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17)!], for: .normal)
        leftNavButton.target = self
        leftNavButton.action = #selector(cancelButtonTapped)
        
        navigationItem.leftBarButtonItem = leftNavButton
        
        // Сохранить
        rightNavButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryLabel")!, NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17)!], for: .normal)
        rightNavButton.target = self
        
        rightNavButton.action = #selector(saveButtonTapped)
        rightNavButton.isEnabled = false
        
        navigationItem.rightBarButtonItem = rightNavButton
    }
    
    func loadItem() {
        do {
            try fileCache.toDoItemsFromJsonFile(file: fileName)
        }
        catch {
            print(FileCacheErrors.fileNotFound)
            
        }
        
        if let item = toDoItem {
            // изменение вида
            elements.placeholder.isHidden = true
            componentsOn()
            
            // достаем нужные значения
            correctId = item.id
            elements.textView.text = item.text
            
            let lines = item.text.components(separatedBy: "\n").count
            // еще изменение вида (высота предстваления)
            var size = settingsZoneHeight + Double(CGFloat(lines * 22) / Aligners.modelHight * Aligners.height)
            // продолжаем достовать значения
            
            let index: Int = {
                var i = 1
                if item.importance == .low { i = 0 }
                if item.importance == .high { i = 2 }
                return i
            }()
            
            elements.segmentedControl.selectedSegmentIndex = index
            
            if let date = item.deadline {
                toggle.setOn(true, animated: true)
                dateManager()
                elements.calendar.setDate(date, animated: true)
                selectDate(date: date)
                size += elements.calendar.frame.height
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
        
        //keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(hideKeyBoard))
        
        toolbar.items = [flexibleSpace, doneButton]
        
        elements.textView.delegate = self
        elements.textView.inputAccessoryView = toolbar
        elements.textView.isScrollEnabled = false
    }

    
    func controlPanelSettings() {
        //располагаем основной вертикальный стэк в горизонтальный стэк, в который помещаем пустые view - отступы.
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
        
        //коллекция view для правой части ячеек
        var actors = [UIView]()
        
        // настройка элементов коллекции
        let segmentedCtrl = elements.segmentedControl
        segmentedCtrl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        
        toggle.addTarget(self, action: #selector(dateManager), for: .valueChanged)
        
        actors.append(segmentedCtrl)
        actors.append(toggle)
        
        // создание ячеек
        for i in 0..<actors.count {
            let HStack = elements.horizontalStacksForCells[i]
            
            // добавляем элементы
            let label = elements.labels[i]
            HStack.addArrangedSubview(label)
            
            let actor = actors[i]
            HStack.addArrangedSubview(actor)
            
           // добавляем HStack-ячейку в основной VStack
            VStack.addArrangedSubview(HStack)
            
            // добавляем разделитель в основной VStack
            if i < elements.dividers.count - 1 { VStack.addArrangedSubview(elements.dividers[i]) }
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


