//
//  CreateBookPresenter.swift
//  BooksAssignment
//
//  Created by omaestra on 4/4/22.
//

import Foundation

protocol CreateBookPresenterProtocol {
    var view: CreateBookViewControllerProtocol? { get set }
    var book: Book? { get }
    var service: BookServiceProtocol { get }
    
    func createBook(model: CreateBookModel)
}

class CreateBookPresenter: CreateBookPresenterProtocol {
    weak internal var view: CreateBookViewControllerProtocol?
    
    var book: Book?
    
    var service: BookServiceProtocol
    
    init(service: BookServiceProtocol) {
        self.service = service
    }
    
    func createBook(model: CreateBookModel) {
        let book = mapBook(model: model)
        service.createBook(book: book) { result in
            switch result {
            case .success(let success):
                if success {
                    self.view?.successfullyCreatedBook(book: book)
                } else {
                    self.view?.displayError()
                }
            case .failure:
                self.view?.displayError()
            }
        }
    }
    
    private func mapBook(model: CreateBookModel) -> Book {
        return Book(id: 9,
                    link: "",
                    title: model.title,
                    author: model.author,
                    price: model.price,
                    image: "",
                    pages: model.pages,
                    releaseDate: String(model.releaseYear))
    }
}
