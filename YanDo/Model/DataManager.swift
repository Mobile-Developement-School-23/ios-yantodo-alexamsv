//
//  DataManager.swift
//  YanDo
//
//  Created by Александра Маслова on 29.06.2023.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    // json
    let fileCache = FileCache()
    let fileName = "YanDoFile"
    // sql
    let sql = SQLBase()
    // coredata
    let coredata = CoreDataBase()
    // items collections
    var completedItems: [ToDoItem] = []
    var pendingItems: [ToDoItem] = []
    private init() {}
}
