//
//  BooksNavigator.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation
import UIKit

final class BooksNavigator: Navigator {
    enum Destination {
        case bookList
        case bookDetails(book: Book)
        case createBook(parentViewController: BooksListTableViewControllerProtocol)
    }
    
    private weak var navigationController: UINavigationController?

    var rootViewController: UIViewController? {
        return navigationController
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigator
    
    func navigate(to destination: Destination, navigationType: NavigationType) {
        let viewController = makeViewController(for: destination)
        
        switch navigationType {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .overlay:
            navigationController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .bookList:
            return BooksListTableTableViewController.instantiate(navigator: self)
        case .bookDetails(let book):
            let service = BookService(network: MockNetworking())
            return BookDetailsViewController.instantiate(book: book, navigator: self, service: service)
        case .createBook(let parentViewController):
            let createBookViewController = CreateBookViewController.instantiate(service: BookService(network: MockNetworking()))
            createBookViewController.delegate = parentViewController
            
            return createBookViewController
        }
    }
}
