//
//  CryptosViewController.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

protocol AllCryptosViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
    var getNumberOfRowsHandler: (() -> Int)? { get set }
    var getContentForCellHandler: (() -> [ViewModelCellCryptoProtocol])? { get set }
    func stopIndicator()
}

final class CryptosViewController: UIViewController {
            
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.isHidden = false
        indicator.startAnimating()
        return indicator
    }()
    
    var presenter: MainViewPresenterProtocol!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationController()
        self.setUpSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Methods
    private func setupNavigationController() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "Cryptocurrencies"
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 25)!]
        
    }
    
    private func setUpSubViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicator)
        self.tableView.frame = self.view.bounds
        self.setupActivityIndicator()

    }
    
    private func setupActivityIndicator() {
        self.activityIndicator.style = .large
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func stopIndicator() {
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: - ComplitionHandlers
    var getNumberOfRowsHandler: (() -> Int)?
    var getContentForCellHandler: (() -> [ViewModelCellCryptoProtocol])?
}
    
    // MARK: - TableView Methods
extension CryptosViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRowsHandler?() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else { fatalError() } 
        cell.selectionStyle = .none
        if indexPath.row.isMultiple(of: 2) {
            cell.cellView.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1)
        } else {
            cell.cellView.backgroundColor = .white
        }
        
        if let cryptos = self.getContentForCellHandler {
            cell.configure(with: cryptos()[indexPath.row])
        }
        return cell
    }
    
}
// MARK: - AllCryptosViewProtocol
extension CryptosViewController: AllCryptosViewProtocol {
    func succes() {
        self.tableView.reloadData()
    }
    
    func failure(error: Error) {
        let alert = UIAlertController(title: "Network Error",
                                      message: "Not received data from the server",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print(error.localizedDescription)
    }
}

