//
//  NetCollections.swift
//  YanDo
//
//  Created by Александра Маслова on 06.07.2023.
//

import Foundation

struct NetList: Codable {
    let status: String
    let list: [NetToDoItem]
    let revision: Int

    init(status: String = "ok", list: [NetToDoItem], revision: Int = 0) {
        self.status = status
        self.list = list
        self.revision = revision
    }
}

 enum NetKeys {
      static let status = "status"
      static let element = "element"
      static let list = "list"
      static let revision = "revision"
  }
