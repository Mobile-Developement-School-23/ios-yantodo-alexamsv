//
//  FileCache.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 15.06.2023.
//
// swiftlint:disable line_length

import Foundation

final class FileCache {
    private(set) var itemsCollection: [String: ToDoItem] = [:]
    @discardableResult
    func addNewToDoItem(_ newItem: ToDoItem) -> ToDoItem? {
        let item = itemsCollection[newItem.id]
        itemsCollection[newItem.id] = newItem
        return item
    }
    @discardableResult
    func deleteToDoItem(itemsID id: String) -> ToDoItem? {
        let item = itemsCollection[id]
        itemsCollection[id] = nil
        return item
    }
    // json
    func saveJsonToDoItemInFile(file: String) throws {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { throw FileCacheErrors.fileNotFound }
        let path = directory.appendingPathComponent("\(file).todo")
        let jsonItems = itemsCollection.map { $1.json }
        let data = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
        try data.write(to: path)
    }
    func toDoItemsFromJsonFile(file: String) throws {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {throw FileCacheErrors.fileNotFound}
        let path = directory.appendingPathComponent("\(file).todo")
        let data = try Data(contentsOf: path)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsn = json as? [Any] else {
            throw FileCacheErrors.failedToExtractData
        }
        let toDoItems = jsn.compactMap { ToDoItem.parseJSON(json: $0) }
        self.itemsCollection = toDoItems.reduce(into: [:]) {res, item in
            res[item.id] = item
        }
    }
    // csv
    func saveCSVToDoItemInFile(file: String) throws {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { throw FileCacheErrors.fileNotFound }
        let path = directory.appendingPathComponent("\(file).csv")
        let csvString = itemsCollection.values.map { $0.csv }.joined(separator: "\n")
        try csvString.write(to: path, atomically: true, encoding: .utf8)
    }
    func toDoItemsFromCSVFile(file: String) throws {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { throw FileCacheErrors.fileNotFound }
        let path = directory.appendingPathComponent("\(file).csv")
        let csvString = try String(contentsOf: path, encoding: .utf8)
        let lines = csvString.components(separatedBy: "\n")
        var deserializedItems: [ToDoItem] = []
        for line in lines {
            guard let item = ToDoItem.parseCSV(line) else {
                print("Failed to parse line: \(line)")
                continue
            }
            deserializedItems.append(item)
        }
        self.itemsCollection = deserializedItems.reduce(into: [:]) { res, item in
            res[item.id] = item
        }
    }
}

enum FileCacheErrors: Error {
    case fileNotFound
    case failedToExtractData
}

// swiftlint:enable line_length
