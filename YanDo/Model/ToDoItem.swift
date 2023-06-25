//
//  ToDoItem.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 12.06.2023.
//

import Foundation


struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let createdDate: Date
    let dateОfСhange: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date?,
        isCompleted: Bool,
        createdDate: Date,
        dateОfСhange: Date?
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdDate = createdDate
        self.dateОfСhange = dateОfСhange
    }
}

enum Importance: String {
    case low
    case normal
    case high
}

// for json format
enum Keys {
    static let id = "id"
    static let text = "text"
    static let importance = "importance"
    static let deadline = "deadline"
    static let isCompleted = "is_completed"
    static let createdDate = "created_date"
    static let dateOfChange = "date_of_change"
}

