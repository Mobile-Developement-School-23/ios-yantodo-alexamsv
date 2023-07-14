//
//  DataManager.swift
//  YanDo
//
//  Created by Александра Маслова on 29.06.2023.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    let fileCache = FileCache()
    // items collections
    var completedItems: [ToDoItem] = []
    var pendingItems: [ToDoItem] = []
    private init() { }
}
