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

final class SearchViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, AddToFavoriteDelegate, SearchViewProtocol { // UISearchBarDelegate
        
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

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubViews()
        self.setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    private func setUpSubViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.tableView.frame = self.view.bounds
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 30)!]
        navigationController?.navigationBar.topItem?.title = "Search Crypto"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
        
    func addToFavorite() {
        tableView.reloadData()
    }
    
    var searchHandler: ((String) -> Void)?
    var getFilteredCryptos: (() -> [ViewModelCellCrypto])?// в протоккол
    
    //MARK: - Search methods
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.replacingOccurrences(of: " ", with: "")
        self.searchHandler?(searchText)
        print("SEARCH \(searchText)")
        tableView.reloadData()
    }
        
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return getFilteredCryptos?().count ?? 0
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
        if searchController.isActive {
            if let cryptos = getFilteredCryptos?() {
                cell.configure(with: cryptos[indexPath.row])
            }
        }
        cell.delegate = self
        return cell
    }
    
}
