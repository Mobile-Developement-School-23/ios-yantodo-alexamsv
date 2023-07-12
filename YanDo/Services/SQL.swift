//
//  SQL.swift
//  YanDo
//
//  Created by Александра Маслова on 11.07.2023.
//
// swiftlint:disable line_length

import Foundation
import CocoaLumberjackSwift
import SQLite

final class SQLData {
    private(set) var itemsCollection: [ToDoItem] = []
    var sqlBase: Connection?

    func toDoItemsFromSQLdatabase() {
        guard let databasePath = getDatabasePath() else { return }

        do {
            sqlBase = try Connection(databasePath)

            let table = Table(Parameters.table)
            let id = Expression<String>(Keys.id)
            let text = Expression<String>(Keys.text)
            let importance = Expression<String>(Keys.importance)
            let deadline = Expression<Int>(Keys.deadline)
            let isCompleted = Expression<Bool>(Keys.isCompleted)
            let createdDate = Expression<Int>(Keys.createdDate)
            let dateOfChange = Expression<Int>(Keys.dateOfChange)

            let items = try sqlBase?.prepare(table)

            for item in items! {
                let idValue = item[id]
                let textValue = item[text]
                let importanceValue = item[importance]
                let deadlineValue = item[deadline]
                let isCompletedValue = item[isCompleted]
                let createdDateValue = item[createdDate]
                let dateOfChangeValue = item[dateOfChange]

                let newItem = ToDoItem(
                    id: idValue,
                    text: textValue,
                    importance: Importance(rawValue: importanceValue) ?? .basic,
                    deadline: deadlineValue != 0 ? Date(timeIntervalSince1970: TimeInterval(deadlineValue)) : nil,
                    isCompleted: isCompletedValue,
                    createdDate: Date(timeIntervalSince1970: TimeInterval(createdDateValue)),
                    dateОfСhange: Date(timeIntervalSince1970: TimeInterval(dateOfChangeValue))
                )
                itemsCollection.append(newItem)
            }
        } catch { DDLogError("SQL: \(error)") }
    }

    func addItemToSQLdatabase(item: ToDoItem) {
        guard let databasePath = getDatabasePath() else {
            DDLogError("Failed to get the path to the SQLite database.")
            return
        }
        do {
            sqlBase = try Connection(databasePath)

            let table = Table(Parameters.table)
            let id = Expression<String>(Keys.id)
            let text = Expression<String>(Keys.text)
            let importance = Expression<String>(Keys.importance)
            let deadline = Expression<Int?>(Keys.deadline)
            let isCompleted = Expression<Bool>(Keys.isCompleted)
            let createdDate = Expression<Int>(Keys.createdDate)
            let dateOfChange = Expression<Int?>(Keys.dateOfChange)

            try sqlBase?.run(table.insert(
                id <- item.id,
                text <- item.text,
                importance <- item.importance.rawValue,
                deadline <- Int(item.deadline?.timeIntervalSince1970 ?? 0),
                isCompleted <- item.isCompleted,
                createdDate <- Int(item.createdDate.timeIntervalSince1970),
                dateOfChange <- Int(item.dateОfСhange?.timeIntervalSince1970 ?? 0)
            ))
            itemsCollection.append(item)
        } catch { DDLogError("SQL: \(error)") }
    }

    func removeItemFromSQLDatabase(id: String) {
        guard let databasePath = getDatabasePath() else { return }

        do {
            sqlBase = try Connection(databasePath)
            let table = Table(Parameters.table)
            let idColumn = Expression<String>(Keys.id)
            let item = table.filter(idColumn == id)

            try sqlBase?.run(item.delete())
            if let index = itemsCollection.firstIndex(where: { $0.id == id }) {
                itemsCollection.remove(at: index)
            }
        } catch { DDLogError("SQL: \(error)") }
    }

    func updateItemInSQLDatabase(id: String, item: ToDoItem) {
        removeItemFromSQLDatabase(id: id)
        let updatedItem = ToDoItem(id: id, text: item.text, importance: item.importance, deadline: item.deadline, isCompleted: item.isCompleted, createdDate: item.createdDate, dateОfСhange: Date())
        addItemToSQLdatabase(item: updatedItem)
    }

    // MARK: - privat

    private func getDatabasePath() -> String? {
        let fileManager = FileManager.default
        let applicationSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first

        guard let appSupportPath = applicationSupportPath else { return nil }
        let databasePath = "\(appSupportPath)/\(Parameters.database).\(Parameters.expansion)"

        if !fileManager.fileExists(atPath: databasePath) {
            do {
                try fileManager.createDirectory(atPath: appSupportPath, withIntermediateDirectories: true, attributes: nil)
            } catch { return nil }
            guard let bundlePath = Bundle.main.path(forResource: Parameters.database, ofType: Parameters.expansion) else { return nil }
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: databasePath)
            } catch { return nil }
        }
        return databasePath
    }

    private enum Parameters {
        static let database = "yandoDatabase"
        static let expansion = "db"
        static let table = "yando"
    }

}

// swiftlint:enable line_length
