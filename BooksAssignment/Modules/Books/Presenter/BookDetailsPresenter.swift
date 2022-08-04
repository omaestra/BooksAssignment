//
//  BookDetailsPresenter.swift
//  BooksAssignment
//
//  Created by omaestra on 4/4/22.
//

import Foundation

protocol BookDetailsPresenterProtocol {
    var view: BookDetailsViewControllerProtocol? { get set }
    var book: Book? { get }
    var service: BookServiceProtocol { get }
    
    func getBookDetails()
}

class BookDetailsPresenter: BookDetailsPresenterProtocol {
    var view: BookDetailsViewControllerProtocol?
    
    var book: Book?
    
    var service: BookServiceProtocol
    
    init(service: BookServiceProtocol) {
        self.service = service
    }
    
    func getBookDetails() {
        guard let bookId = self.book?.id else {
            return
        }
        service.getBook(bookId: bookId) { [weak self] result in
            switch result {
            case .success(let book):
                self?.book = book
                self?.view?.updateView(with: book)
            case .failure:
                self?.book = nil
                self?.view?.displayError()
            }
        }
    }
}
