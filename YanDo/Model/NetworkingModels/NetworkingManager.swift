//
//  NetworkingManager.swift
//  YanDo
//
//  Created by Александра Маслова on 06.07.2023.
//

import Foundation

class NetworkingManager {
    static let shared = NetworkingManager()
    let urlSession: URLSession = URLSession(configuration: .default)
    let baseURL = "https://beta.mrdekk.ru/todobackend"
    let token = "chatty"
    var revision = 0
    var toDoItemsFromNet: [ToDoItem] = []
    private init() {}
}
