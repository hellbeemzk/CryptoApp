//
//  Assembly.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

final class Assembly {
    
    private init() {}
    
    static let shared: Assembly = .init()
    
    var model: ModelCryptosProtocol = ModelCryptos()
    var favoriteService : FavoriteServiceProtocol = FavoriteService()
    
    private func createMainModule() -> UIViewController {
        let view = CryptosViewController()
        let networkService = NetworkService()
        let presenter = CryptosPresenter(view: view, networkService: networkService, model: model )
        view.presenter = presenter
        return view
    }
    
    private func favoriteViewController() -> UIViewController {
        let view = FavoriteCryptosViewController()
        let presenter = FavoriteCryptosPresenter(view: view, model: model )
        view.presenter = presenter
        return view
    }
    
    private func searchViewController() -> UIViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
    
    func tabBarController() -> UIViewController { // может быть вынести в отдельную сущность
        let tabBar = UITabBarController()
        
        let allCryptosVC = createMainModule()
        allCryptosVC.tabBarItem = UITabBarItem(title: "All Crypto",
                                               image: UIImage(systemName: "chart.bar.doc.horizontal"),
                                               tag: 0)
        let favoriteCryptosVC = favoriteViewController()
        favoriteCryptosVC.tabBarItem = UITabBarItem(title: "Favorite",
                                                    image: UIImage(systemName: "star"),
                                                    tag: 1)
        let searchVC = searchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search",
                                           image: UIImage(systemName: "magnifyingglass"),
                                           tag: 2)
        tabBar.viewControllers = [allCryptosVC, favoriteCryptosVC, searchVC].map { UINavigationController (rootViewController: $0)}
        tabBar.tabBar.tintColor = .black
        return tabBar
    }
    
}
