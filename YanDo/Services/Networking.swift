//
//  Networking.swift
//  YanDo
//
//  Created by Александра Маслова on 06.07.2023.
//
// swiftlint:disable unused_closure_parameter
// swiftlint:disable line_length

import Foundation
import UIKit

class DefaultNetworkingService {
    let networkingManager = NetworkingManager.shared
    var netToDoItems: [ToDoItem] = []

    func getCorrectRevision(completion: @escaping (Result<Void, Error>) -> Void) {
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

    func patchToDoItems(completion: @escaping (Result<Void, Error>) -> Void) {
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

    
    func postToDoItem(item: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void) {
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
            
            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
    

    func deleteItem(withId: String, completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func createJSONElement(from netToDoItem: NetToDoItem, revision: Int) -> Data? {
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

}
enum NetworkingError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case jsonSerializationFailed
}
// swiftlint:enable unused_closure_parameter
// swiftlint:enable line_length
