//
//  SearchPresenter.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewProtocol, model: ModelCryptosProtocol)
}

final class SearchPresenter : SearchPresenterProtocol {
    
    private weak var view: SearchViewProtocol?
    private let model: ModelCryptosProtocol
    
    init(view: SearchViewProtocol, model: ModelCryptosProtocol) {
        self.view = view
        self.model = model
        self.setHandlers()
    }
    
    private var searchText: String = ""
    
    private func setHandlers() {
        self.view?.getFilteredCryptos  = { [weak self] in
            self?.getFilteredCryptos() ?? []
        }
        
        self.view?.searchHandler = { [weak self] text in
            self?.searchText = text
        }
    }
    
    private func getFilteredCryptos() -> [ViewModelCellCrypto] {
        self.model.getAllCryptos().filter { crypto in // либо вьюмодели оставить в презентере, либо общаться с моделью через презентер
            if (searchText != "") {
                return crypto.symbol.lowercased().contains(searchText.lowercased()) ||       crypto.name.lowercased().contains(searchText.lowercased())
            } else {
                return false
            }
        }
    }
    
}
