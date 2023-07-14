//
//  ViewElementsForTaskScreen.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 21.06.2023.
//
// swiftlint:disable line_length

import UIKit

class ViewElementsForTaskScreen {
    // MARK: text panel
    let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondaryBack
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let textView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.textColor = UIColor.primaryLabel
        text.font = UIFont.body
        text.textContainerInset = .zero
        text.textContainer.lineFragmentPadding = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let placeholder: UILabel = {
        let text = UILabel()
        text.text = Text.placeholder
        text.font = UIFont.body
        text.textColor = UIColor.tertiaryLabel
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    // MARK: control panel
    static let cellsCount = 2
    let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.layer.cornerRadius = 16
        stack.backgroundColor = UIColor.secondaryBack
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let leadingSpacer: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.widthAnchor.constraint(equalToConstant: 16 / Aligners.modelWidth * Aligners.width).isActive = true
        return spacer
    }()
    let trailingSpacer: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.widthAnchor.constraint(equalToConstant: 12 / Aligners.modelWidth * Aligners.width).isActive = true
        return spacer
    }()
    let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let horizontalStacksForCells: [UIStackView] = {
        var arr = [UIStackView]()
        for _ in 0..<cellsCount {
            var stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.heightAnchor.constraint(greaterThanOrEqualToConstant: 56 / Aligners.modelHight * Aligners.height).isActive = true
            arr.append(stack)
        }
        return arr
    }()
    let labels: [UILabel] = {
        var arr = [UILabel]()
        let titles = [Text.importance, Text.deadline]
        for title in titles {
            let label = UILabel()
            label.text = title
            label.textColor = UIColor.primaryLabel
            label.font = UIFont.body
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 22 / Aligners.modelHight * Aligners.height).isActive = true
            arr.append(label)
        }
        return arr
    }()
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(with: Images.importanceLow.uiImage.withRenderingMode(.alwaysOriginal), at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: Text.not, at: 1, animated: true)
        segmentedControl.insertSegment(with: Images.importanceHight.uiImage.withRenderingMode(.alwaysOriginal), at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.heightAnchor.constraint(equalToConstant: 36 / Aligners.modelHight * Aligners.height).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 150 / Aligners.modelWidth * Aligners.width).isActive = true
        return segmentedControl
    }()
    let horizontalStacksForDate: UIStackView = {
            var stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = 3 / Aligners.modelWidth * Aligners.width
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.heightAnchor.constraint(equalToConstant: 18 / Aligners.modelHight * Aligners.height).isActive = true
        return stack
    }()
    let calendarButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.blueColor, for: .normal)
        button.titleLabel?.font = UIFont.footnote
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 18 / Aligners.modelHight * Aligners.height).isActive = true
        // Устанавливаем следующий день в качестве заголовка кнопки
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        var dateComponents = DateComponents()
        dateComponents.day = 1
        let nextDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        var nextDateFormatted = dateFormatter.string(from: nextDate ?? currentDate)
        if nextDateFormatted.hasPrefix("0") {nextDateFormatted.removeFirst()} // если число с 1 по 9 включительно
        button.setTitle(nextDateFormatted, for: .normal)
        return button
    }()
    let slash: UILabel = {
        let text = UILabel()
        text.text = Text.slash
        text.font = UIFont.footnote
        text.textColor = UIColor.grayLightColor
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let timerButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.grayLightColor, for: .normal)
        button.titleLabel?.font = UIFont.footnote
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 18 / Aligners.modelHight * Aligners.height).isActive = true
        button.setTitle(Text.remind, for: .normal)
        return button
    }()

    let timer: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.heightAnchor.constraint(equalToConstant: 200 / Aligners.modelHight * Aligners.height).isActive = true
        return picker
    }()

    let calendar: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.preferredDatePickerStyle = .inline
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.heightAnchor.constraint(equalToConstant: 333 / Aligners.modelHight * Aligners.height).isActive = true
        // Устанавливаем следующий день как выбранную дату по умолчанию
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = 1
        let nextDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        picker.setDate(nextDate ?? currentDate, animated: false)
        // Выключаем возможность выбора даты в прошлом
        picker.minimumDate = currentDate
        return picker
    }()

    let dividers: [UIView] = {
        var arr = [UIView]()
        for _ in 0..<cellsCount {
            let divider = UIView()
            divider.backgroundColor = UIColor.separatorSupport
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale).isActive = true
            arr.append(divider)
        }
        return arr
    }()
    // MARK: delete panel
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.secondaryBack
        button.setTitle(Text.delete, for: .normal)
        button.titleLabel?.font = UIFont.body
        button.setTitleColor(UIColor.tertiaryLabel, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 56 / Aligners.modelHight * Aligners.height).isActive = true
        return button
    }()
}
// swiftlint:enable line_length
