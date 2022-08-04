//
//  BooksListTableTableViewController.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit

protocol BooksListTableViewControllerProtocol: AnyObject {
    func reload()
    func displayError()
    func addNewBook(book: Book)
}

class BooksListTableTableViewController: UITableViewController {
    var presenter: BooksListPresenterProtocol?
    private var navigator: BooksNavigator?
    
    static func instantiate(navigator: BooksNavigator) -> BooksListTableTableViewController {
        let controller = BooksListTableTableViewController()
        let presenter = BooksListPresenter(service: BookService(network: MockNetworking()))
        presenter.view = controller
        
        controller.presenter = presenter
        controller.navigator = navigator
        
        return controller
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle()
        configureNavigationBar()
        configureTableView()
        
        presenter?.fetchBooks(offset: 0, count: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func configureTitle() {
        title = "Books"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationItem.titleView?.tintColor = .black
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createButtonTapped))
    }
    
    private func configureTableView() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshBooksData(_:)), for: .valueChanged)
        
        let nib = UINib(nibName: BookTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.presenter?.books?.count ?? 0 > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            let errorView = ErrorView(frame: self.view.frame)
            errorView.titleLabel.text = "There are no books yet"
            errorView.descriptionLabel.text = nil
            tableView.backgroundView = errorView
            
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.books?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseIdentifier, for: indexPath) as! BookTableViewCell
        
        cell.configureView(title: presenter?.books?[indexPath.row].title)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = presenter?.getBook(at: indexPath) else {
            return
        }
        
        navigator?.navigate(to: .bookDetails(book: book))
    }
    
    // MARK: - Actions
    
    @objc func createButtonTapped() {
        navigator?.navigate(to: .createBook(parentViewController: self), navigationType: .overlay)
    }
    
    @objc private func refreshBooksData(_ sender: Any) {
        presenter?.fetchBooks()
    }
}

extension BooksListTableTableViewController: BooksListTableViewControllerProtocol {
    func displayError() {
        self.refreshControl?.endRefreshing()
        let alertController = UIAlertController(title: "Oops!",
                          message: "An error ocurred trying to retrieve the books :(",
                          preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Got it",
                                   style: .default, handler: nil)
        
        alertController.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        self.refreshControl?.endRefreshing()
    }
    
    func addNewBook(book: Book) {
        self.presenter?.addNewBook(book: book)
    }
}
