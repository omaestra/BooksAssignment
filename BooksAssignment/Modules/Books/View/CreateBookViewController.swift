//
//  CreateBookViewController.swift
//  BooksAssignment
//
//  Created by omaestra on 4/4/22.
//

import UIKit

protocol CreateBookViewControllerProtocol: AnyObject {
    func successfullyCreatedBook(book: Book)
    func displayError()
}

class CreateBookViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var pagesTextField: UITextField!
    @IBOutlet weak var releaseYearTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingValueLabel: UILabel!
    
    var presenter: CreateBookPresenterProtocol?
    weak var delegate: BooksListTableViewControllerProtocol?
    
    let validator = Validator()
    
    static func instantiate(service: BookServiceProtocol) -> CreateBookViewController {
        let viewController = CreateBookViewController()
        let presenter = CreateBookPresenter(service: service)
        presenter.view = viewController
        viewController.presenter = presenter
        
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDismissKeyboardGesture()
    }
    
    private func createBook() {
        let title = titleTextField.text ?? ""
        let author = authorTextField.text ?? ""
        let price = priceTextField.text ?? ""
        let pages = pagesTextField.text ?? ""
        let releaseYear = releaseYearTextField.text ?? ""
        let rating = ratingSlider.value
        
        let model = CreateBookModel(
            title: title,
            author: author,
            price: Double(price) ?? 0,
            pages: Int(pages) ?? 0,
            releaseYear: Int(releaseYear) ?? 0,
            rating: Double(rating)
        )
        
        presenter?.createBook(model: model)
    }
    
    private func addDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        let validTitle = validator.validate(input: titleTextField, with: [.notEmpty])
        let validAuthor = validator.validate(input: authorTextField, with: [.notEmpty])
        let validPrice = validator.validate(input: priceTextField, with: [.notEmpty, .validNumber])
        let validPages = validator.validate(input: pagesTextField, with: [.notEmpty, .validNumber])
        let validReleaseYear = validator.validate(input: releaseYearTextField, with: [.notEmpty, .validNumber])
        
        if validTitle,
           validAuthor,
           validPrice,
           validPages,
           validReleaseYear {
            createBook()
        }
    }
    
    @IBAction func ratingSliderValueChanged(_ sender: UISlider) {
        ratingValueLabel.text = "\(Int(sender.value))"
    }
}

extension CreateBookViewController: CreateBookViewControllerProtocol {
    func successfullyCreatedBook(book: Book) {
        let alertController = UIAlertController(title: "Success!",
                          message: "Successfully created a new book!",
                          preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok",
                                   style: .default) { _ in
            self.dismiss(animated: true) {
                self.delegate?.addNewBook(book: book)
            }
        }
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayError() {
        let alertController = UIAlertController(title: "Oops!",
                          message: "An error ocurred trying to create a book",
                          preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Got it",
                                   style: .default, handler: nil)
        
        alertController.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
