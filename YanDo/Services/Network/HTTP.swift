//
//  HTTP.swift
//  YanDo
//
//  Created by Александра Маслова on 08.07.2023.
//
import Foundation

struct NetworkResponse {
    static func handleNetworkResponse(for response: HTTPURLResponse?) -> Result<Void, HTTPError> {
        guard let response = response else {
            return .failure(HTTPError.failedResponseUnwrapping)
        }
        switch response.statusCode {
        case 200: return .success(())
        case 400: return .failure(HTTPError.wrongRequest)
        case 401: return .failure(HTTPError.authenticationError)
        case 404: return .failure(HTTPError.notFound)
        case 500...599: return .failure(HTTPError.serverSideError)
        default: return .failure(HTTPError.failed)
        }
    }
}
public enum HTTPError: String, Error {
    case failed = "Error: Network request failed"
    case missingURL = "Error: URL is missing"
    case missingURLComponents = "Error: URL components are missing"
    case failedResponseUnwrapping = "Error: Failed to unwrap response"
    case badRequest = "Error: Bad request"
    case authenticationError = "Error: Failed to authenticate"
    case serverSideError = "Error: Server error"
    case decodingFailed = "Error: Failed to decode data"
    case wrongRequest = "Error: wrong request / invalid url / unsynchronizedData"
    case notFound = "Error: Element not found on server."
    case retryCountToMuch = "Error: To much tries on server."
}
