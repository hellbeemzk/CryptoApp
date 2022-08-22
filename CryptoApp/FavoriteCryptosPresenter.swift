//
//  FavoriteCryptosPresenter.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

protocol FavoritePresenterProtocol: AnyObject {
    init(view: FavoriteViewProtocol, model: ModelCryptosProtocol)
}

final class FavoriteCryptosPresenter : FavoritePresenterProtocol {

    private weak var view: FavoriteViewProtocol?
    private let model: ModelCryptosProtocol // protocol
    
    init(view: FavoriteViewProtocol, model: ModelCryptosProtocol) {
        self.view = view
        self.model = model
        self.setHandlers()
    }
    
    private func setHandlers() {
        self.view?.getNumberOfRowsFavotireCryptosHandler = { [weak self] in
            self?.getNumberOfFavoriteCryptos() ?? 0
        }
        
        self.view?.getFavoriteCryptoHandler = { [weak self] in
            self?.getFavoriteCrypto() ?? []
        }
    }
    
    private func getNumberOfFavoriteCryptos() -> Int {
        self.model.getAllCryptos().filter { $0.isFavorite }.count
    }
    
    private func getFavoriteCrypto() -> [ViewModelCellCrypto] {
        self.model.getAllCryptos().filter { $0.isFavorite }
    }
    
}
