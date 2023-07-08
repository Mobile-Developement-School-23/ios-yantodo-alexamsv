//
//  NetworkingService.swift
//  YanDo
//
//  Created by Александра Маслова on 06.07.2023.
//
// swiftlint:disable unused_closure_parameter
// swiftlint:disable line_length
// swiftlint:disable trailing_whitespace
// swiftlint:disable type_body_length

import Foundation
import UIKit

protocol NetworkingService: AnyObject {
    var networkingService: DefaultNetworkingService { get }
    var itemsFromNet: [ToDoItem] { get set }
    var indicator: Bool { get set }
}

class DefaultNetworkingService {
   private let networkingManager = NetworkingManager.shared
   var netToDoItems: [ToDoItem] = []
    
    @discardableResult
    func getCorrectInfFromNet() -> Bool {
        var isSuccess = false
        
        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global().async {
            self.getFromApi { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success:
                    print("POST: Запрос выполнен успешно")
                    self.networkingManager.isDirty = false
                    isSuccess = true
                case .failure(let error):
                    print("POST: Произошла ошибка при выполнении запроса: \(error)")
                    self.networkingManager.isDirty = true
                }
            }
        }
        group.wait()

        return isSuccess
    }
    
    func updateListFromNet(completion: @escaping (Bool) -> Void) {
        patch { result in
            switch result {
            case .success:
                print("PATCH: Обновление выполнено успешно")
                DispatchQueue.main.async {
                    completion(true)
                    self.networkingManager.isDirty = false
                }
            case .failure(let error):
                print("PATCH: Произошла ошибка при обновлении: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                    self.networkingManager.isDirty = true
                }
            }
        }
    }
    
    func addNewToDoItemToNet(item: ToDoItem, completion: @escaping (Bool) -> Void) {
        post(item: item) { result in
            switch result {
            case .success:
                print("POST: Обновление выполнено успешно")
                DispatchQueue.main.async {
                    completion(true)
                    self.networkingManager.isDirty = false
                }
            case .failure(let error):
                print("POST: Произошла ошибка при обновлении: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                    self.networkingManager.isDirty = true
                }
            }
        }
        
    }
    
    func deleteToDoItemFromNet(id: String, completion: @escaping (Bool) -> Void) {
        delete(withId: id) { result in
            switch result {
            case .success:
                print("DELETE: Обновление выполнено успешно")
                DispatchQueue.main.async {
                    completion(true)
                    self.networkingManager.isDirty = false
                }
            case .failure(let error):
                print("DELETE: Произошла ошибка при обновлении: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                    self.networkingManager.isDirty = true
                }
            }
        }
        
    }
    
    func updateToDoItemFromNet(id: String, item: ToDoItem, completion: @escaping (Bool) -> Void) {
        put(withId: id, newItem: item) { result in
            switch result {
            case .success:
                print("PUT: Обновление выполнено успешно")
                DispatchQueue.main.async {
                    completion(true)
                    self.networkingManager.isDirty = false
                }
            case .failure(let error):
                print("PUT: Произошла ошибка при обновлении: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                    self.networkingManager.isDirty = true
                }
            }
        }
    }

    // MARK: - privat

   private func getFromApi(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(networkingManager.baseURL)/list") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(networkingManager.token)"
        ]

        let task = networkingManager.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let result = json as? [String: Any] else {
                    completion(.failure(NetworkingError.invalidResponse))
                    return
                }

                if let status = result[NetKeys.status] as? String, status == "ok" {
                    if let revision = result[NetKeys.revision] as? Int {
                        self.networkingManager.revision = revision
                    }
                    completion(.success(()))
                } else {
                    completion(.failure(NetworkingError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

  private  func patch(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(networkingManager.baseURL)/list") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(networkingManager.token)",
            "X-Last-Known-Revision": "\(networkingManager.revision)"
        ]

        let task = networkingManager.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let netList = try decoder.decode(NetList.self, from: data)
                if netList.status == "ok" {
                    self.netToDoItems = netList.list.map { netToDoItem in
                        return ToDoItem(
                            id: netToDoItem.id,
                            text: netToDoItem.text,
                            importance: Importance(rawValue: netToDoItem.importance) ?? .low,
                            deadline: netToDoItem.deadline.map { Date(timeIntervalSince1970: TimeInterval($0)) },
                            isCompleted: netToDoItem.isCompleted,
                            createdDate: Date(timeIntervalSince1970: TimeInterval(netToDoItem.createdDate)),
                            dateОfСhange: Date(timeIntervalSince1970: TimeInterval(netToDoItem.dateОfСhange))
                        )
                    }
                    self.networkingManager.revision = netList.revision
                    completion(.success(()))
                } else {
                    completion(.failure(NetworkingError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

   private func post(item: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(networkingManager.baseURL)/list") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        if let jsonData = createJSONElement(from: NetToDoItem.init(from: item), revision: NetworkingManager.shared.revision) {
                request.httpBody = jsonData
            } else {
                completion(.failure(NetworkingError.jsonSerializationFailed))
                return
            }

        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(networkingManager.token)",
            "X-Last-Known-Revision": "\(NetworkingManager.shared.revision)"
        ]

        let task = networkingManager.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard data != nil else {
                completion(.failure(NetworkingError.noData))
                return
            }

            completion(.success(()))
        }

        task.resume()
    }

  private func delete(withId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(networkingManager.baseURL)/list/" + withId) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        print(networkingManager.revision)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(networkingManager.token)",
            "X-Last-Known-Revision": "\(networkingManager.revision)"
        ]

            let task = networkingManager.urlSession.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.networkingManager.revision += 1
                        completion(.success(()))
                    } else {
                        let error = NSError(domain: "NetworkingError", code: httpResponse.statusCode, userInfo: nil)
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NetworkingError.invalidResponse))
                }
            }

            task.resume()
        }
    
  private func put(withId id: String, newItem: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(networkingManager.baseURL)/list/\(id)") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        if let jsonData = createJSONElement(from: NetToDoItem(from: newItem), revision: NetworkingManager.shared.revision) {
            request.httpBody = jsonData
        } else {
            completion(.failure(NetworkingError.jsonSerializationFailed))
            return
        }
        
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(networkingManager.token)",
            "X-Last-Known-Revision": "\(NetworkingManager.shared.revision)"
        ]
        
        let task = networkingManager.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.networkingManager.revision += 1
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "NetworkingError", code: httpResponse.statusCode, userInfo: nil)
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NetworkingError.invalidResponse))
            }
        }
        
        task.resume()
    }

  private func createJSONElement(from netToDoItem: NetToDoItem, revision: Int) -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        do {
            let jsonData = try encoder.encode(netToDoItem)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            let jsonObject: [String: Any] = [
                "status": "ok",
                "element": json,
                "revision": revision
            ]
            return try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        } catch {
            print("Error creating JSON: \(error)")
            return nil
        }
    }
    
   private enum NetworkingError: Error {
        case invalidURL
        case noData
        case invalidResponse
        case jsonSerializationFailed
    }

}

// swiftlint:enable trailing_whitespace
// swiftlint:enable unused_closure_parameter
// swiftlint:enable line_length
// swiftlint:enable type_body_length
