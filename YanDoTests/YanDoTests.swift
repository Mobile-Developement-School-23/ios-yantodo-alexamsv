//
//  ToDoListAppTests.swift
//  ToDoListAppTests
//
//  Created by Александра Маслова on 12.06.2023.
//
// swiftlint:disable line_length
// swiftlint:disable force_try

import XCTest
@testable import YanDo

final class ToDoListAppTests: XCTestCase {
    // MARK: tests for ToDoItem
    // Проверка init объекта с заданными значениями и сравнивнение свойсв созданного объекта с ожидаемыми значениями.
        func testToDoItemInit() {
            let id = "19"
            let text = "Write a Unit-test"
            let importance = Importance.high
            let deadline = Date().addingTimeInterval(360)
            let isCompleted = false
            let createdDate = Date()
            let dateOfChange: Date? = nil
            let todoItem = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, createdDate: createdDate, dateОfСhange: dateOfChange)
            XCTAssertEqual(todoItem.id, id)
            XCTAssertEqual(todoItem.text, text)
            XCTAssertEqual(todoItem.importance, importance)
            XCTAssertEqual(todoItem.deadline, deadline)
            XCTAssertEqual(todoItem.isCompleted, isCompleted)
            XCTAssertEqual(todoItem.createdDate, createdDate)
            XCTAssertEqual(todoItem.dateОfСhange, dateOfChange)
        }

    // Проверка  метода `parseJSON`  (при некорректном JSON вернет nil)
        func testParseJSON_InvalidJSON_ReturnsNil() {
            let json: [String: Any] = [
                "id": "testID",
                "text": "Test todo item"
            ]
            let parsedItem = ToDoItem.parseJSON(json: json)
            XCTAssertNil(parsedItem)
        }
    // Проверка заданного объекта  в формате JSON и его соответствие ожидаемому JSON.
    func testJSON_ReturnsCorrectJSONRepresentation() {
        let id = "testID"
        let text = "Test todo item"
        let importance = Importance.high
        let deadline = Date()
        let isCompleted = false
        let createdDate = Date()
        let dateOfChange = Date().addingTimeInterval(60)
        let todoItem = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, createdDate: createdDate, dateОfСhange: dateOfChange)
        let expectedJSON: [String: Any] = [
            "id": id,
            "text": text,
            "importance": importance.rawValue,
            "deadline": Int(deadline.timeIntervalSince1970),
            "is_completed": isCompleted,
            "created_date": Int(createdDate.timeIntervalSince1970),
            "date_of_change": Int(dateOfChange.timeIntervalSince1970)
        ]
        let json = todoItem.json as? [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json as NSDictionary?, expectedJSON as NSDictionary?)
    }
    // Проверка  метода `parseJSON` (проверка извлечения JSON и соответсвиея ожидаемому объекту)
    func testJSONParsing() {
        let json: [String: Any] = [
            "id": "id",
            "text": "Test todo item",
            "deadline": 1678924800,
            "is_completed": true,
            "created_date": 1678872000,
            "date_of_change": 1678893600
        ]
        let todoItem = ToDoItem.parseJSON(json: json)
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, "id")
        XCTAssertEqual(todoItem?.text, "Test todo item")
        XCTAssertEqual(todoItem?.importance, .normal)
        XCTAssertEqual(todoItem?.deadline, Date(timeIntervalSince1970: 1678924800))
        XCTAssertTrue(todoItem?.isCompleted ?? false)
        XCTAssertEqual(todoItem?.createdDate, Date(timeIntervalSince1970: 1678872000))
        XCTAssertEqual(todoItem?.dateОfСhange, Date(timeIntervalSince1970: 1678893600))
    }
    // Проверка сериализации объекта в формат JSON
    func testJSONSerialization() {
        let todoItem = ToDoItem(
            id: "123456",
            text: "Test todo item",
            importance: .high,
            deadline: Date(timeIntervalSince1970: 1678924800),
            isCompleted: true,
            createdDate: Date(timeIntervalSince1970: 1678872000),
            dateОfСhange: Date(timeIntervalSince1970: 1678893600)
        )
        let jsonData = try? JSONSerialization.data(withJSONObject: todoItem.json, options: [])
        XCTAssertNotNil(jsonData)
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
        XCTAssertNotNil(jsonObject)
        XCTAssertTrue(jsonObject is [String: Any])
        if let jsonDictionary = jsonObject as? [String: Any] {
            XCTAssertEqual(jsonDictionary["id"] as? String, "123456")
            XCTAssertEqual(jsonDictionary["text"] as? String, "Test todo item")
            XCTAssertEqual(jsonDictionary["importance"] as? String, "high")
            XCTAssertEqual(jsonDictionary["deadline"] as? Int, 1678924800)
            XCTAssertEqual(jsonDictionary["is_completed"] as? Bool, true)
            XCTAssertEqual(jsonDictionary["created_date"] as? Int, 1678872000)
            XCTAssertEqual(jsonDictionary["date_of_change"] as? Int, 1678893600)
        } else {
            XCTFail("Invalid JSON object")
        }
    }
 // MARK: tests for FileCache
   private var fileCache: FileCache!
   private let newItem = ToDoItem(text: "Test Item", importance: .normal, deadline: nil, isCompleted: false, createdDate: Date(), dateОfСhange: Date().addingTimeInterval(60))
    override func setUp() {super.setUp(); fileCache = FileCache()}
    override func tearDown() {fileCache = nil; super.tearDown()}
    // Тест проверяет, что объект был успешно добавлен в коллекцию
    func testAddNewToDoItem() {
        let addedItem = fileCache.addNewToDoItem(newItem)
        XCTAssertNil(addedItem) // Проверяем, что предыдущий элемент не возвращается
        XCTAssertEqual(fileCache.itemsCollection[newItem.id]?.id, newItem.id)
        XCTAssertEqual(fileCache.itemsCollection[newItem.id]?.text, newItem.text)
    }

    // Тест проверяет, что объект был успешно удален из коллекции
    func testDeleteToDoItem() {
        fileCache.addNewToDoItem(newItem)
        let deletedItem = fileCache.deleteToDoItem(itemsID: newItem.id)
        XCTAssertNotNil(deletedItem)
        XCTAssertEqual(deletedItem?.id, newItem.id)
        XCTAssertEqual(deletedItem?.text, newItem.text)
        XCTAssertNil(fileCache.itemsCollection[newItem.id])
    }
    // Тест проверяет, что коллекция объектов была успешно добавлен в в файл в формате JSON
    func testSaveJsonToDoItemInFile() {
        let item1 = ToDoItem(text: "Item 1", importance: .normal, deadline: nil, isCompleted: false, createdDate: Date(), dateОfСhange: Date().addingTimeInterval(30))
        let item2 = ToDoItem(text: "Item 2", importance: .high, deadline: Date().addingTimeInterval(180), isCompleted: false, createdDate: Date(), dateОfСhange: nil)
        fileCache.addNewToDoItem(item1)
        fileCache.addNewToDoItem(item2)
        let fileName = "TestFile"
        XCTAssertNoThrow(try fileCache.saveJsonToDoItemInFile(file: fileName))
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent("\(fileName).todo")
        XCTAssertTrue(fileManager.fileExists(atPath: filePath.path))
        try? fileManager.removeItem(at: filePath)
    }
    // Тест проверяет, что коллекция объектов была успешно загружена из файла в формате JSON
    func testToDoItemsFromJsonFile() {
        let fileName = "TestFile"
        let jsonItems: [[String: Any]] = [
            [
                "id": "1",
                "text": "Test todo item1",
                "deadline": 1678924800,
                "is_completed": true,
                "created_date": 1678872000,
                "date_of_change": 1678893600
            ],
            [
                "id": "2",
                "text": "Test todo item 2",
                "importance": "high",
                "is_completed": false,
                "created_date": 1678872000
            ]
        ]
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent("\(fileName).todo")
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonItems, options: [])
        try! jsonData.write(to: filePath)
        XCTAssertNoThrow(try fileCache.toDoItemsFromJsonFile(file: fileName))
        XCTAssertEqual(fileCache.itemsCollection.count, jsonItems.count)
        try? fileManager.removeItem(at: filePath)
    }
    // MARK: system functions
    // override func setUpWithError() throws {}
    // override func tearDownWithError() throws {}
    // func testExample() throws {}
    // func testPerformanceExample() throws {self.measure {}}
}
// swiftlint:enable line_length
// swiftlint:enable force_try
