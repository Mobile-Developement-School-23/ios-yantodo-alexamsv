//
//  FileCache.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 15.06.2023.
//

import Foundation
import CocoaLumberjackSwift
/// this class is disabled. SQL and CoreData are used
final class FileCache {
    private(set) var itemsCollection: [String: ToDoItem] = [:]
    @discardableResult
    func addNewToDoItem(_ newItem: ToDoItem) -> ToDoItem? {
        let item = itemsCollection[newItem.id]
        itemsCollection[newItem.id] = newItem
        DDLogInfo("Added new ToDoItem with ID: \(newItem.id)")
        return item
    }

    @discardableResult
    func deleteToDoItem(itemsID id: String) -> ToDoItem? {
        let item = itemsCollection[id]
        itemsCollection[id] = nil
        DDLogInfo("Deleted ToDoItem with ID: \(id)")
        return item
    }
    // json
    func saveJsonToDoItemInFile(file: String) {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            let error = FileCacheErrors.fileNotFound
            DDLogError("Failed to get document directory: \(error)")
            return
        }
        let path = directory.appendingPathComponent("\(file).todo")
        let jsonItems = itemsCollection.map { $1.json }
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
            try data.write(to: path)
            DDLogInfo("JSON data saved to file: \(path)")
        } catch {
            DDLogError("Failed to save JSON data to file: \(error)")
        }
    }
    func toDoItemsFromJsonFile(file: String) {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            let error = FileCacheErrors.fileNotFound
            DDLogError("Failed to get document directory: \(error)")
            return
        }
        let path = directory.appendingPathComponent("\(file).todo")
        do {
            let data = try Data(contentsOf: path)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsn = json as? [Any] else {
                let error = FileCacheErrors.failedToExtractData
                DDLogError("Failed to extract data from JSON: \(error)")
                return
            }
            let toDoItems = jsn.compactMap { ToDoItem.parseJSON(json: $0) }
            self.itemsCollection = toDoItems.reduce(into: [:]) { res, item in
                res[item.id] = item
            }
            DDLogInfo("Successfully loaded ToDoItems from JSON file: \(path)")
        } catch {
            DDLogError("Failed to load ToDoItems from JSON file: \(error)")
        }
    }
    // csv
    func saveCSVToDoItemInFile(file: String) {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            let error = FileCacheErrors.fileNotFound
            DDLogError("Failed to get document directory: \(error)")
            return
        }
        let path = directory.appendingPathComponent("\(file).csv")
        let csvString = itemsCollection.values.map { $0.csv }.joined(separator: "\n")
        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            DDLogInfo("CSV data saved to file: \(path)")
        } catch {
            DDLogError("Failed to save CSV data to file: \(error)")
        }
    }
    func toDoItemsFromCSVFile(file: String) {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            let error = FileCacheErrors.fileNotFound
            DDLogError("Failed to get document directory: \(error)")
            return
        }
        let path = directory.appendingPathComponent("\(file).csv")
        do {
            let csvString = try String(contentsOf: path, encoding: .utf8)
            let lines = csvString.components(separatedBy: "\n")
            var deserializedItems: [ToDoItem] = []
            for line in lines {
                guard let item = ToDoItem.parseCSV(line) else {
                    DDLogWarn("Failed to parse line: \(line)")
                    continue
                }
                deserializedItems.append(item)
            }
            self.itemsCollection = deserializedItems.reduce(into: [:]) { res, item in
                res[item.id] = item
            }
            DDLogInfo("Successfully loaded ToDoItems from CSV file: \(path)")
        } catch {
            DDLogError("Failed to load ToDoItems from CSV file: \(error)")
        }
    }
}

enum FileCacheErrors: Error {
    case fileNotFound
    case failedToExtractData
}
