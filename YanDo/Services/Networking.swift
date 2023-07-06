//
//  Networking.swift
//  YanDo
//
//  Created by Александра Маслова on 06.07.2023.
//
// swiftlint:disable unused_closure_parameter

import Foundation
import YanDoItem

class DefaultNetworkingService {
    let networkingManager = NetworkingManager.shared
    var netToDoItems: [ToDoItem] = []

    func getToDoItems(completion: @escaping (Result<Void, Error>) -> Void) {
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

                   if let status = result["status"] as? String, status == "ok" {
                       if let revision = result["revision"] as? Int {
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
}

enum NetworkingError: Error {
    case invalidURL
    case noData
    case invalidResponse
}
// swiftlint:enable unused_closure_parameter
