//
//  NetworkingService.swift
//  YanDo
//
//  Created by Александра Маслова on 08.07.2023.
//

import Foundation

protocol NetworkingService: AnyObject {
    var networkingService: DefaultNetworkingService { get }
    var itemsFromNet: [ToDoItem] { get set }
    var indicator: Bool { get set }
}
