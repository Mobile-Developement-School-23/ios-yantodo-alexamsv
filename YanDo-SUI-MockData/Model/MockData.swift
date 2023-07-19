//
//  MockData.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 18.07.2023.
//
// swiftlint:disable line_length

import Foundation

final class MockData {
    let mock = [
        ToDoItem(text: "Выпить кофе", importance: .basic, deadline: nil, isCompleted: false, createdDate: Date(), dateОfСhange: nil),
        ToDoItem(text: "Задать миллион вопросов в техническом чате ШМР", importance: .low, deadline: nil, isCompleted: false, createdDate: Date(), dateОfСhange: nil),
        ToDoItem(text: "Сверстать экраны приложения на SwiftUI, в которой будут отображаться mock данные", importance: .important, deadline: nil, isCompleted: true, createdDate: Date(), dateОfСhange: nil),
        ToDoItem(text: "Сдать дз не в последний день", importance: .basic, deadline: Date(timeIntervalSince1970: 1689967492), isCompleted: true, createdDate: Date(), dateОfСhange: nil),
        ToDoItem(text: "Пройти на стажировку", importance: .important, deadline: nil, isCompleted: false, createdDate: Date(), dateОfСhange: nil),
        ToDoItem(text: """
Заказать Яндекс Лавку:
Яблоки
Кефир
Глазированные сырки
""", importance: .basic, deadline: nil, isCompleted: false, createdDate: Date(), dateОfСhange: nil),
        ToDoItem(text: "Покормить кота", importance: .important, deadline: Date(), isCompleted: false, createdDate: Date(), dateОfСhange: nil),
        ToDoItem(text: "Найти appicon для этого приложения", importance: .basic, deadline: Date(timeIntervalSince1970: 1690485892), isCompleted: false, createdDate: Date(), dateОfСhange: nil)
    ]
}
// swiftlint:enable line_length
