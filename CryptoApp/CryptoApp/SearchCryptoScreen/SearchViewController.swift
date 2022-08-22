//
//  SearchViewController.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    var searchHandler: ((String) -> Void)? { get set }
    var getFilteredCryptos: (() -> [ViewModelCellCrypto])? { get set }
}

final class SearchViewController: UIViewController, SearchViewProtocol { 
    
    //MARK: - Properties
    var presenter: SearchPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.loadViewIfNeeded()
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.font = UIFont(name: "Montserrat-Bold", size: 5)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        return searchController
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubViews()
        self.setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Methods
    private func setUpSubViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.tableView.frame = self.view.bounds
    }
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 30)!]
        self.navigationController?.navigationBar.topItem?.title = "Search Crypto"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - ComplitionHandlers
    var searchHandler: ((String) -> Void)?
    var getFilteredCryptos: (() -> [ViewModelCellCrypto])?
}

// MARK: - AddToFavoriteDelegate
extension SearchViewController: AddToFavoriteDelegate {
    func addToFavorite() {
        self.tableView.reloadData()
    }
}

// MARK: - Search methods
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.replacingOccurrences(of: " ", with: "")
        self.searchHandler?(searchText)
        self.tableView.reloadData()
    }
}

// MARK: - TableView Methods
extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.getFilteredCryptos?().count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else { fatalError() }
        cell.selectionStyle = .none
        if indexPath.row.isMultiple(of: 2) {
            cell.cellView.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1)
        } else {
            cell.cellView.backgroundColor = .white
        }
        if self.searchController.isActive {
            if let cryptos = getFilteredCryptos?() {
                cell.configure(with: cryptos[indexPath.row])
            }
        }
        cell.delegate = self
        return cell
    }
}
