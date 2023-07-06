//
//  NetCollections.swift
//  YanDo
//
//  Created by Александра Маслова on 06.07.2023.
//

import Foundation

struct NetElement: Codable {
    let status: String
    let element: NetToDoItem
    let revision: Int

    init(status: String = "ok", element: NetToDoItem, revision: Int = 0) {
        self.status = status
        self.element = element
        self.revision = revision
    }

  private enum Keys {
        static let status = "status"
        static let element = "element"
        static let revision = "revision"
    }
}

struct NetList: Codable {
    let status: String
    let list: [NetToDoItem]
    let revision: Int

    init(status: String = "ok", list: [NetToDoItem], revision: Int = 0) {
        self.status = status
        self.list = list
        self.revision = revision
    }

   private enum Keys {
        static let status = "status"
        static let list = "list"
        static let revision = "revision"
    }
}
