//
//  FavoriteService.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import Foundation

protocol FavoriteServiceProtocol {
    func isFavorite(for name: String) -> Bool
    func saveFavoriteCryptos(name: String)
    func removeFavoriteCrypto(name: String)
}

final class FavoriteService: FavoriteServiceProtocol {
    
    //MARK: - Properties
    private var storage = UserDefaults.standard
    private var storageKey = "faforite cryptos"
    
    private lazy var favorites: [String] = {
        self.storage.stringArray(forKey: storageKey) ?? []
    }()
    
    //MARK: - Methods
    func isFavorite(for name: String) -> Bool {
        self.favorites.contains(name) 
    }
    
    func saveFavoriteCryptos(name: String) {
        self.favorites.append(name)
        self.saveInStorageFavoriteCryptos()
    }
    
    func removeFavoriteCrypto(name: String) {
        if let index = self.favorites.firstIndex(where: {$0 == name }) {
            self.favorites.remove(at: index)
            self.saveInStorageFavoriteCryptos()
        }
    }
    
    func saveInStorageFavoriteCryptos() {
        self.storage.set(self.favorites, forKey: storageKey)
    }
    
}
