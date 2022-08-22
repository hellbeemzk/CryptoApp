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

private var storage = UserDefaults.standard
private var storageKey = "faforite cryptos"

private lazy var favorites: [String] = {
    self.storage.stringArray(forKey: storageKey) ?? []
}()

func isFavorite(for name: String) -> Bool {
    if self.favorites.contains(name) {
        print("EST TAKOE \(name)")
        return true
    } else {
        print("NETUUU TAKOE \(false)")
        return false
    }
}

func saveFavoriteCryptos(name: String) {
    self.favorites.append(name)
    print("FAVORITE ZAGRUZHENO \(favorites)")
    saveInStorageFavoriteCryptos()
    }

func removeFavoriteCrypto(name: String) {
    if let index = self.favorites.firstIndex(where: {$0 == name }) {
        self.favorites.remove(at: index)
        print("FAVORITE UDALENO \(favorites)")
        saveInStorageFavoriteCryptos()
}
}


func saveInStorageFavoriteCryptos() {
    print("=====DOBAVLENO ILI UDALENO FAVORITE STORAGE \(self.favorites)")
    self.storage.set(self.favorites, forKey: storageKey)
}

}
