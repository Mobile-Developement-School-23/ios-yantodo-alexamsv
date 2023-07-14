//
//  NotificationCenter.swift
//  YanDo
//
//  Created by Александра Маслова on 14.07.2023.
//

import UIKit
import UserNotifications

// Функция для добавления уведомления в список планов
func scheduleNotification(date: Date, time: Date, text: String, identifier: String) {
    let content = UNMutableNotificationContent()
    content.title = "YanDo"

        let lines = text.split(separator: "\n")
        let trimmedText = lines.prefix(3).joined(separator: "\n")
        
        content.body = trimmedText

    var notificationComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)

    let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
    notificationComponents.hour = timeComponents.hour
    notificationComponents.minute = timeComponents.minute

    let trigger = UNCalendarNotificationTrigger(dateMatching: notificationComponents, repeats: false)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
        } else {
            print("Уведомление успешно добавлено в список планов")
        }
    }
}

// Функция для отмены запланированного уведомления по идентификатору
func cancelNotification(identifier: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    print("Уведомление с идентификатором \(identifier) успешно отменено")
}
