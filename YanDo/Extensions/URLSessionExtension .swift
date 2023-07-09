//
//  URLSessionExtension .swift
//  YanDo
//
//  Created by Александра Маслова on 04.07.2023.
//
// swiftlint:disable line_length

import Foundation
import CocoaLumberjackSwift

extension URLSession {
    func dataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation({ continuation in
            // Создание задачи для сетевого запроса с использованием переданного URLRequest
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    DDLogError("Error occurred during network request: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
                guard let data = data, let response = response else {
                    // Создание и запись сообщения об отсутствии данных или ответа
                    let error = NSError(domain: "URLSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "No response or data received"])
                    DDLogError("No response or data received during network request")
                    continuation.resume(throwing: error)
                    return
                }
                // Асинхронное возобновление выполнения с полученными данными и ответом
                DispatchQueue.main.async {
                    continuation.resume(returning: (data, response))
                }
            }
            // Проверяем, была ли задача отменена
            if Task.isCancelled {
                task.cancel()
            } else {
                task.resume()
            }
        })
    }
}
// swiftlint:enable line_length
