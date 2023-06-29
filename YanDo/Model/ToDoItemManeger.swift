//
//  ToDoItemManeger.swift
//  YanDo
//
//  Created by Александра Маслова on 29.06.2023.
//

import UIKit

extension MainScreenViewController: CustomTableViewCellDelegate {
    //пометить item как выполненый
    func toDoItemIsCompleted(in cell: CustomTableViewCell) {
        // получаем item
        if let indexPath = elements.tableView.indexPath(for: cell) {
            var item: ToDoItem
            if !showCompletedToDoItems {
                 item = pendingItems[indexPath.row]
            } else {
                 item = pendingItems[indexPath.row - completedItems.count]
            }
            
            // перезаписываем item
            let newCompletedToDoItem = ToDoItem(text: item.text, importance: item.importance, deadline: item.deadline, isCompleted: true, createdDate: item.createdDate, dateОfСhange: item.dateОfСhange)
            fileCache.deleteToDoItem(itemsID: item.id)
            fileCache.addNewToDoItem(newCompletedToDoItem)
            do {
                try fileCache.saveJsonToDoItemInFile(file: fileName)
            } catch {
                print(FileCacheErrors.failedToExtractData)
            }
        }
        // обнавляем таблицу
        completedItems = Array(fileCache.itemsCollection.values).filter { $0.isCompleted }
        pendingItems = Array(fileCache.itemsCollection.values).filter { !$0.isCompleted }
        elements.tableView.reloadData()
       
    }
    
    //пометить item как ожидающий
    func toDoItemIsPending(in cell: CustomCompletedTableViewCell) {
        // получаем item
        if let indexPath = elements.tableView.indexPath(for: cell) {
            let item = completedItems[indexPath.row]
            
            // перезаписываем item
            let newCompletedToDoItem = ToDoItem(text: item.text, importance: item.importance, deadline: item.deadline, isCompleted: false, createdDate: item.createdDate, dateОfСhange: item.dateОfСhange)
            fileCache.deleteToDoItem(itemsID: item.id)
            fileCache.addNewToDoItem(newCompletedToDoItem)
            do {
                try fileCache.saveJsonToDoItemInFile(file: fileName)
            } catch {
                print(FileCacheErrors.failedToExtractData)
            }
        }
        // обнавляем таблицу
        completedItems = Array(fileCache.itemsCollection.values).filter { $0.isCompleted }
        pendingItems = Array(fileCache.itemsCollection.values).filter { !$0.isCompleted }
        elements.tableView.reloadData()
        
    }
    
}

