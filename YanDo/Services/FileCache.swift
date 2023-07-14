//
//  FileCache.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 15.06.2023.
//
// swiftlint:disable for_where

import Foundation
import CocoaLumberjackSwift

final class FileCache {
    private(set) var itemsCollection: [ToDoItem] = []
    private let sql = SQLBase()
    private let coredata = CoreDataBase()

    func toDoItemsFromDatabases() {
        sql.toDoItemsFromSQLdatabase()
        coredata.toDoItemsFromCoreDatabase()
        getCollection()
    }
    func addItemToDatabases(item: ToDoItem) {
        sql.addItemToSQLdatabase(item: item)
        coredata.addItemToCoreDatabase(item: item)
        getCollection()
    }

    func deleteItemFromDatabases(id: String) {
        sql.deleteItemFromSQLDatabase(id: id)
        coredata.deleteItemFromCoreDatabase(id: id)
        getCollection()
    }

    func updateItemInDatabases(id: String, item: ToDoItem) {
        sql.updateItemInSQLDatabase(id: id, item: item)
        coredata.updateItemInCoreDataBase(id: id, item: item)
        getCollection()
    }

    private func getCollection() {
        let combinedItems = coredata.itemsCollection + coredata.itemsCollection
        // Удаление дублирующихся элементов на основе id
        var uniqueItems = [ToDoItem]()
        var encounteredIDs = Set<String>()
        for item in combinedItems {
            if !encounteredIDs.contains(item.id) {
                uniqueItems.append(item)
                encounteredIDs.insert(item.id)
            }
        }
        itemsCollection = uniqueItems
    }
}
// swiftlint:enable for_where
