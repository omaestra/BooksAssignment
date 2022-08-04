//
//  BookDetailsViewController.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit
import Kingfisher

protocol BookDetailsViewControllerProtocol: AnyObject {
    func updateView(with book: Book)
    func displayError()
}

class BookDetailsViewController: UIViewController {
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var pagesValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var errorView: ErrorView!
    
    var presenter: BookDetailsPresenterProtocol?
    weak private var navigator: BooksNavigator?
    
    static func instantiate(book: Book, navigator: BooksNavigator, service: BookServiceProtocol) -> BookDetailsViewController {
        let controller = BookDetailsViewController()
        let presenter = BookDetailsPresenter(service: service)
        presenter.book = book
        presenter.view = controller
        
        controller.presenter = presenter
        controller.navigator = navigator
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        
        self.presenter?.getBookDetails()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func setupView() {
        detailsContainerView.layer.cornerRadius = 8.0
        detailsContainerView.layer.masksToBounds = true
        detailsContainerView.clipsToBounds = true
        infoContainerView.layer.cornerRadius = 8.0
        infoContainerView.layer.masksToBounds = true
        infoContainerView.clipsToBounds = true
    }
}

extension BookDetailsViewController: BookDetailsViewControllerProtocol {
    func updateView(with book: Book) {
        DispatchQueue.main.async {
            self.titleLabel.text = book.title
            self.authorLabel.text = book.author
            self.priceValueLabel.text = (book.price.map { String($0) } ?? "-") + " $"
            self.pagesValueLabel.text = book.pages.map({ String($0) }) ?? "-"
            self.ratingValueLabel.text = book.rating.map({ String($0) }) ?? "-"
            self.descriptionTextView.text = book.description
            if let imageUrl = book.image, let url = URL(string: imageUrl) {
                self.bookImageView.kf.indicatorType = .activity
                self.bookImageView.kf.setImage(with: url)
            }
        }
    }
    
    func displayError() {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.tintColor = .red
            self.imageContainerView.isHidden = true
            self.detailsContainerView.isHidden = true
            self.bookImageView.isHidden = true
            self.errorView.isHidden = false
        }
    }
}
