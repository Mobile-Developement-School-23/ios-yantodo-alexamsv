//
//  DateFormatterExtension.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 19.06.2023.
//

import Foundation

// для csv не использую timeIntervalSince1970 тк хочу сразу читаемую строку
extension DateFormatter {
    static let csvDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
