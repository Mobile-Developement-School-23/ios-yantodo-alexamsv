//
//  DataManager.swift
//  YanDo
//
//  Created by Александра Маслова on 29.06.2023.
//

import Foundation
import YanDoItem

class DataManager {
    static let shared = DataManager()
    let fileCache = FileCache()
    let fileName = "YanDoFile"
    var completedItems: [ToDoItem] = []
    var pendingItems: [ToDoItem] = []
    private init() {}
}
