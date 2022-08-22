//
//  ViewModelCellCrypto.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import Foundation

protocol ViewModelCellCryptoProtocol {
    var name: String     { get }
    var symbol: String   { get }
    var price: String    { get }
    var iconUrl: URL?    { get }
    var iconData: Data?  { get }
    var isFavorite: Bool { get }
    func setFavorite()
}

class ViewModelCellCrypto: ViewModelCellCryptoProtocol { 
    
    // MARK: - Properties
    var name: String
    var symbol: String
    var price: String
    var iconUrl: URL?
    var iconData: Data?
    var isFavorite: Bool
    
    private var favoriteService: FavoriteServiceProtocol
    
    // MARK: - Initialization
    init(name: String, symbol: String, price: String, iconUrl: URL?){
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
        self.favoriteService = Assembly.shared.favoriteService
        self.isFavorite = favoriteService.isFavorite(for: name)
    }
    
    // MARK: - Method
    func setFavorite() {
        self.isFavorite.toggle()
        
        if self.isFavorite {
            self.favoriteService.saveFavoriteCryptos(name: self.name)
        } else {
            self.favoriteService.removeFavoriteCrypto(name: self.name)
            }
        }
    
    }
