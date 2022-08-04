//
//  BooksListPresenter.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation

protocol BooksListPresenterProtocol: AnyObject {
    var view: BooksListTableViewControllerProtocol? { get set }
    var books: [Book]? { get }
    var service: BookServiceProtocol { get }
    
    func fetchBooks(offset: Int?, count: Int?)
    func getBook(at indexPath: IndexPath) -> Book?
    func addNewBook(book: Book)
}

extension BooksListPresenterProtocol {
    func fetchBooks(offset: Int? = nil, count: Int? = nil) {
        return fetchBooks(offset: offset, count: count)
    }
}

class BooksListPresenter: BooksListPresenterProtocol {
    var books: [Book]?
    
    internal var service: BookServiceProtocol
    
    weak internal var view: BooksListTableViewControllerProtocol?
    
    init(service: BookServiceProtocol) {
        self.service = service
    }
    
    func fetchBooks(offset: Int?, count: Int?) {
        service.fetchBooks(offset: offset, count: count) { [weak self] result in
            switch result {
            case .success(let books):
                self?.books = books
                self?.view?.reload()
            case .failure(let error):
                self?.books = nil
                self?.view?.displayError()
                debugPrint(error)
            }
        }
    }
    
    func getBook(at indexPath: IndexPath) -> Book? {
        return books?[indexPath.row]
    }
    
    func addNewBook(book: Book) {
        self.books?.append(book)
        view?.reload()
    }
}
