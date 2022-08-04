//
//  CustomError.swift
//  BooksAssignment
//
//  Created by omaestra on 4/4/22.
//

import Foundation

enum CustomError: Error {
    case notFound
    case unexpected(code: Int)
}

extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notFound:
            return "Oops! The item you are looking for could not be found."
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
}
