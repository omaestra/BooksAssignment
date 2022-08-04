//
//  Endpoint.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation
import Alamofire

enum Endpoint {
    case books(offset: Int?, count: Int?)
    case book(id: Int)
    case createBook
}

extension Endpoint: URLRequestConvertible {
    // MARK: - Path
    
    private var path: String {
        switch self {
        case .books:
            return "api/v1/items"
            
        case .book(id: let id):
            return "api/v1/items/\(id)"
            
        case .createBook:
            return "api/v1/items"
        }
    }
    
    // MARK: - HTTPMethod
    
    var method: HTTPMethod {
        switch self {
        case .books, .book:
            return .get
            
        case .createBook:
            return .post
        }
    }
    
    // MARK: - Parameters
    
    private var parameters: Parameters? {
        switch self {
        case .books(let offset, let count):
            var params: Parameters? = [:]
            if let offset = offset {
                params?["offset"] = offset
            }
            if let count = count {
                params?["count"] = count
            }
            
            return params
            
        case .book:
            return nil
            
        case .createBook:
            return nil
        }
    }
    
    var encoding: URLEncoding {
        switch self {
        case .books:
            return .queryString
        case .book:
            return .default
        case .createBook:
            return .httpBody
        }
    }
    
    var mockFileName: String {
        switch self {
        case .books:
            return "books"
            
        case .book(let id):
            return "book_\(id)"
            
        case .createBook:
            return "items"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
