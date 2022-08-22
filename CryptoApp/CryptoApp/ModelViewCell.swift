//
//  ModelViewCell.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import Foundation

protocol ViewModelCellCryptoProtocol {
    var name: String { get set }
    var symbol: String { get set }
    var price: String { get set }
    var iconUrl: URL? { get set }
    var iconData: Data? { get set }
    var isFavorite: Bool { get set }
    func setFavorite()
}

class ViewModelCellCrypto: ViewModelCellCryptoProtocol { // protocol
    var name: String
    var symbol: String
    var price: String
    var iconUrl: URL?
    var iconData: Data?
    var isFavorite: Bool
    
    private var favoriteService: FavoriteServiceProtocol
    
    init(name: String, symbol: String, price: String, iconUrl: URL?){
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
        self.favoriteService = Assembly.shared.favoriteService
        self.isFavorite = favoriteService.isFavorite(for: name)
    }
    
    func setFavorite() {
        isFavorite.toggle()
        print("\(self.name) + \(self.isFavorite)")
        
        if isFavorite {
            self.favoriteService.saveFavoriteCryptos(name: self.name)
        } else {
            self.favoriteService.removeFavoriteCrypto(name: self.name)
            }
        }
    }
