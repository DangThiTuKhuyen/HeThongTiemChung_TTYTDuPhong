//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation
import Alamofire

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]

typealias Completion<Value> = (Result<Value>) -> Void
typealias APICompletion = (APIResult) -> Void
typealias CompletionAPI = (ResultAPI) -> Void

enum APIResult {
    case success
    case failure(Error)
}

enum ResultAPI {
    case success
    case failure(String)
}

// MARK: - Equatable

extension APIResult: Equatable {

    public static func == (lhs: APIResult, rhs: APIResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError.code == rhsError.code && lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

// MARK: - Get error for api result
extension APIResult {

    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

let api = ApiManager()

final class ApiManager {

    var defaultHTTPHeaders: [String: String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        return headers
    }

    var authorizationAccessHTTPHeaders: [String: String] {
        var headers: [String: String] = defaultHTTPHeaders
        headers["Authorization"] = "Bearer " + (UserDefaults.standard.string(forKey: "accessToken") ?? "")
        return headers
    }
}
