//
//  BookService.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation

protocol BookServiceProtocol {
    var network: NetworkingProtocol { get }
    
    func fetchBooks(offset: Int?, count: Int?, completion: @escaping (Result<[Book], Error>) -> Void)
    func getBook(bookId: Int, completion: @escaping (Result<Book, Error>) -> Void)
    func createBook(book: Book, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class BookService: BookServiceProtocol {
    var network: NetworkingProtocol
    
    init(network: NetworkingProtocol) {
        self.network = network
    }
    
    func fetchBooks(offset: Int?, count: Int?, completion: @escaping (Result<[Book], Error>) -> Void) {
        network.fetch(.books(offset: offset, count: count)) { (result: Result<[Book], Error>) in
            switch result {
            case .success(let books):
                let offsetBooks = books.enumerated().filter({ $0.offset >= offset ?? 0 }).map({ $0.element })
                let pagedBooks = Array(offsetBooks.prefix(count ?? offsetBooks.count))
                
                completion(.success(pagedBooks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getBook(bookId: Int, completion: @escaping (Result<Book, Error>) -> Void){
        network.fetch(.book(id: bookId)) { (result: Result<Book, Error>) in
            switch result {
            case .success(let book):
                completion(.success(book))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createBook(book: Book, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let bookData = try JSONSerialization.jsonObject(with: JSONEncoder().encode(book)) as? [String: Any] ?? [:]
            network.create(.createBook, requestBody: bookData) { (result: Result<Book, Error>) in
                switch result {
                case .success:
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch (let error) {
            completion(.failure(error))
        }
    }
}
