//
//  FavoriteCryptosViewController.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

protocol FavoriteViewProtocol: AnyObject {
    var getNumberOfRowsFavotireCryptosHandler: (() -> Int)? { get set }
    var getFavoriteCryptoHandler: (() -> [ViewModelCellCrypto])? { get set }
}

protocol AddToFavoriteDelegate: AnyObject {
    func addToFavorite()
}

final class FavoriteCryptosViewController: UIViewController, FavoriteViewProtocol {
    
    // MARK: - Properties
    var presenter: FavoritePresenterProtocol!
    
    private lazy var tableView: UITableView = { //
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.dataSource = self
        return tableView
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
    
    // MARK: - ComplitionHandlers
    var getNumberOfRowsFavotireCryptosHandler: (() -> Int)?
    var getFavoriteCryptoHandler: (() -> [ViewModelCellCrypto])?
    
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
        self.navigationController?.navigationBar.topItem?.title = "Favorite Crypto"
    }
}

    // MARK: - AddToFavoriteDelegate
extension FavoriteCryptosViewController: AddToFavoriteDelegate {
    func addToFavorite() {
        self.tableView.reloadData()
    }
}

    // MARK: - TableView Methods
extension FavoriteCryptosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRowsFavotireCryptosHandler?() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else { fatalError() }
        cell.selectionStyle = .none
        if indexPath.row.isMultiple(of: 2) {
            cell.cellView.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1) // убрать в константы
        } else {
            cell.cellView.backgroundColor = .white
        }
        if let favoriteCryptos = self.getFavoriteCryptoHandler {
            cell.configure(with: favoriteCryptos()[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
}
