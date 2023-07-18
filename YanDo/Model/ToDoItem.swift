//
//  ToDoItem.swift
//  ToDoListApp
//
//  Created by Александра Маслова on 12.06.2023.
//
// swiftlint:disable line_length

import Foundation

struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let timing: Date?
    let isCompleted: Bool
    let createdDate: Date
    let dateОfСhange: Date?
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date?,
        timing: Date?,
        isCompleted: Bool,
        createdDate: Date,
        dateОfСhange: Date?
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.timing = timing
        self.isCompleted = isCompleted
        self.createdDate = createdDate
        self.dateОfСhange = dateОfСhange
    }
}
enum Importance: String {
    case low
    case basic
    case important
}
// for databases
enum Keys {
    static let id = "id"
    static let text = "text"
    static let importance = "importance"
    static let deadline = "deadline"
    static let timing = "timing"
    static let isCompleted = "done"
    static let createdDate = "created_at"
    static let dateOfChange = "changed_at"

    static let sqlQuery: String = """
       \(Keys.id),
       \(Keys.text),
       \(Keys.importance),
       \(Keys.deadline),
       \(Keys.isCompleted),
       \(Keys.createdDate),
       \(Keys.dateOfChange),
       """
}

extension ToDoItem {
    // json format
    static func parseJSON(json: Any) -> ToDoItem? {
        guard let jsonData = json as? [String: Any] else {
            print("json data not found")
            return nil
        }
        guard let id = jsonData[Keys.id] as? String,
              let text = jsonData[Keys.text] as? String,
              let createdDate = (jsonData[Keys.createdDate] as? Int).flatMap({Date(timeIntervalSince1970: TimeInterval($0))})
        else {return nil}
        let importance = (jsonData[Keys.importance] as? String).flatMap(Importance.init(rawValue:)) ?? .basic
        let deadline = (jsonData[Keys.deadline] as? Int).flatMap({Date(timeIntervalSince1970: TimeInterval($0))})
        let timing = (jsonData[Keys.timing] as? Int).flatMap({Date(timeIntervalSince1970: TimeInterval($0))})
        let isCompleted = (jsonData[Keys.isCompleted] as? Bool) ?? false
        let dateОfСhange = (jsonData[Keys.dateOfChange] as? Int).flatMap({Date(timeIntervalSince1970: TimeInterval($0))})
        return ToDoItem(id: id, text: text, importance: importance, deadline: deadline, timing: timing, isCompleted: isCompleted, createdDate: createdDate, dateОfСhange: dateОfСhange)
    }
    var json: Any {
        var jsn: [String: Any] = [:]
        jsn[Keys.id] = id
        jsn[Keys.text] = text
        if importance != .basic {jsn[Keys.importance] = importance.rawValue}
        if let deadline = deadline {jsn[Keys.deadline] = Int(deadline.timeIntervalSince1970)}
        jsn[Keys.isCompleted] = isCompleted
        jsn[Keys.createdDate] = Int(createdDate.timeIntervalSince1970)
        if let dateОfСhange = dateОfСhange {jsn[Keys.dateOfChange] = Int(dateОfСhange.timeIntervalSince1970)}
        return jsn
    }
    // CSV format
    static func parseCSV(_ csvString: String) -> ToDoItem? {
        let components = csvString.components(separatedBy: ";")
        guard components.count == 7 else {
            print("csv data not correct")
            return nil
        }
        let id = components[0]
        let text = components[1]
        let importance = Importance(rawValue: components[2]) ?? .basic
        let deadline = DateFormatter.csvDateFormatter.date(from: components[3])
        let timing = DateFormatter.csvDateFormatter.date(from: components[4])
        let isCompleted = Bool(components[5]) ?? false
        let createdDate = DateFormatter.csvDateFormatter.date(from: components[6]) ?? Date()
        let dateОfСhange = DateFormatter.csvDateFormatter.date(from: components[7])
        return ToDoItem(id: id, text: text, importance: importance, deadline: deadline, timing: timing, isCompleted: isCompleted, createdDate: createdDate, dateОfСhange: dateОfСhange)
    }
    var csv: String {
        var csvString = "\(id);\(text);"
        if importance != .basic {
            csvString += "\(importance.rawValue);"
        } else {
            csvString += ";"
        }
        if let deadline = deadline {
            csvString += "\(DateFormatter.csvDateFormatter.string(from: deadline));"
        } else {
            csvString += ";"
        }
        if let timing = timing {
            csvString += "\(DateFormatter.csvDateFormatter.string(from: timing));"
        } else {
            csvString += ";"
        }
        csvString += "\(isCompleted);\(DateFormatter.csvDateFormatter.string(from: createdDate));"
        if let dateОfСhange = dateОfСhange {csvString += "\(DateFormatter.csvDateFormatter.string(from: dateОfСhange));"}
        return csvString
    }
    // sql format
    var sqlReplaceStatement: String {
        "REPLACE INTO list (\(Keys.sqlQuery)) VALUES ('\(self.id)', '\(self.text)', '\(self.importance)', \(self.deadline.flatMap({ String($0.timeIntervalSince1970)}) ?? "NULL"), \(self.isCompleted ? 1 : 0), \(self.createdDate.timeIntervalSince1970), \(self.dateОfСhange.flatMap({ String($0.timeIntervalSince1970)}) ?? "NULL"), '')"
    }

    var sqlDeleteStatement: String {
        "DELETE FROM list WHERE \(Keys.id) = '\(self.id)'"
    }

    var sqlInsertStatement: String {
        "INSERT INTO list (\(Keys.sqlQuery)) VALUES ('\(self.id)', '\(self.text)', '\(self.importance)', \(self.deadline.flatMap({ String($0.timeIntervalSince1970)}) ?? "NULL"), \(self.isCompleted ? 1 : 0), \(self.createdDate.timeIntervalSince1970), \(self.dateОfСhange.flatMap({ String($0.timeIntervalSince1970)}) ?? "NULL"))"
    }
}
// swiftlint:enable line_length
