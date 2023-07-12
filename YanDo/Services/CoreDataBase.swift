//
//  CoreDataBase.swift
//  YanDo
//
//  Created by Александра Маслова on 12.07.2023.
//
// swiftlint:disable line_length

import UIKit
import CocoaLumberjackSwift
import CoreData

class CoreDataBase {
    private(set) var itemsCollection: [ToDoItem] = []

    func toDoItemsFromCoreDatabase() {
        let fetchRequest: NSFetchRequest<CoreDataItem> = CoreDataItem.fetchRequest()
        do {
            let results = try CoreDataStack.shared.context.fetch(fetchRequest)
            itemsCollection = results.map { convertToToDoItem(coreDataItem: $0) }
        } catch {
            DDLogError("CoreData: \(error)")
        }
    }

    func addItemToCoreDatabase(item: ToDoItem) {
        let coreDataItem = CoreDataItem(context: CoreDataStack.shared.context)
        coreDataItem.id = item.id
        coreDataItem.text = item.text
        coreDataItem.importance = item.importance.rawValue
        coreDataItem.deadline = item.deadline
        coreDataItem.done = item.isCompleted
        coreDataItem.created_at = item.createdDate
        coreDataItem.changed_at = item.dateОfСhange
        CoreDataStack.shared.saveContext()
        itemsCollection.append(item)
    }

    func deleteItemFromCoreDatabase(id: String) {
        let fetchRequest: NSFetchRequest<CoreDataItem> = CoreDataItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try CoreDataStack.shared.context.fetch(fetchRequest)
            guard let itemToDelete = results.first else { return }
            CoreDataStack.shared.context.delete(itemToDelete)
            CoreDataStack.shared.saveContext()
            if let index = itemsCollection.firstIndex(where: { $0.id == id }) {
                itemsCollection.remove(at: index)
            }
        } catch {
            DDLogError("CoreData: \(error)")
        }
    }
    func updateItemInCoreDataBase(id: String, item: ToDoItem) {
        deleteItemFromCoreDatabase(id: id)
        let updatedItem = ToDoItem(id: id, text: item.text, importance: item.importance, deadline: item.deadline, isCompleted: item.isCompleted, createdDate: item.createdDate, dateОfСhange: Date())
        addItemToCoreDatabase(item: updatedItem)
    }

    private func convertToToDoItem(coreDataItem: CoreDataItem) -> ToDoItem {
        let importance = Importance(rawValue: coreDataItem.importance ?? "") ?? .basic
        return ToDoItem(
            id: coreDataItem.id ?? "",
            text: coreDataItem.text ?? "",
            importance: importance,
            deadline: coreDataItem.deadline,
            isCompleted: coreDataItem.done,
            createdDate: coreDataItem.created_at ?? Date(),
            dateОfСhange: coreDataItem.changed_at
        )
    }
}

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "yandoCoredata")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                DDLogError("CoreData: \(error)")
            }
        }
    }
}
// swiftlint:enable line_length
