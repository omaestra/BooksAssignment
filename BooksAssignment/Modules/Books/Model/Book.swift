//
//  Book.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation

struct Book: Codable {
    let id: Int
    var link: String? = nil
    let title: String
    var author: String? = nil
    var price: Double? = nil
    var image: String? = nil
    var pages: Int? = nil
    var releaseDate: String? = nil
    var rating: Double? = nil
    var description: String? = nil
}
