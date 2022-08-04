//
//  Constants.swift
//  BooksAssignment
//
//  Created by omaestra on 4/4/22.
//

import Foundation

struct Constants {
    static let baseUrl = "https://d6e22d5c-8837-477e-8a5d-b3bd73f0055a.mock.pstmn.io"
    
    enum Parameters {
        static let bookId = "bookId"
        static let offset = "offset"
        static let count = "count"
    }
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}
