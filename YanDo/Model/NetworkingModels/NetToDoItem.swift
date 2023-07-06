//
//  NetToDoItem.swift
//  YanDo
//
//  Created by Александра Маслова on 06.07.2023.
//

import Foundation
import YanDoItem
import UIKit

struct NetToDoItem: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int?
    let isCompleted: Bool
    let createdDate: Int
    let dateОfСhange: Int
    let color: String?
    let deviceId: String

    init(from toDoItem: ToDoItem) {
        self.id = toDoItem.id
        self.text = toDoItem.text
        self.importance = toDoItem.importance.rawValue
        self.deadline = toDoItem.deadline.flatMap { Int($0.timeIntervalSince1970) }
        self.isCompleted = toDoItem.isCompleted
        self.createdDate = Int(toDoItem.createdDate.timeIntervalSince1970)
        self.dateОfСhange = Int((toDoItem.dateОfСhange ?? toDoItem.createdDate).timeIntervalSince1970)
        self.color = nil
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case isCompleted = "done"
        case createdDate = "created_at"
        case dateОfСhange = "changed_at"
        case color
        case deviceId = "last_updated_by"
    }
}
