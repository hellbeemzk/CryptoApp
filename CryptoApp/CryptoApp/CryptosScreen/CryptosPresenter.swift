//
//  CryptosPresenter.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

protocol MainViewPresenterProtocol: AnyObject {
    init (view: AllCryptosViewProtocol, networkService: NetworkServiceProtocol, model: ModelCryptosProtocol)
}

final class CryptosPresenter: MainViewPresenterProtocol {
    
    // MARK: - Properties
    private let model: ModelCryptosProtocol
    private weak var view: AllCryptosViewProtocol?
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    init(view: AllCryptosViewProtocol, networkService: NetworkServiceProtocol, model: ModelCryptosProtocol) {
        self.view = view
        self.networkService = networkService
        self.model = model
        self.setHandlers()
        self.getIcons()
        self.getAllCryptos()
    }
    
     private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.formatterBehavior = .default
        return formatter
    }()
    
    // MARK: - Methods
    private func setHandlers() {
        self.view?.getNumberOfRowsHandler = { [weak self] in
            return self?.getNumberOfCryptos() ?? 0
        }
        
        self.view?.getContentForCellHandler = { [weak self] in
            return self?.getAllCryptosFromModel() ?? []
        }
    }
    
    private func getNumberOfCryptos() -> Int {
        return self.model.getAllCryptos().count
    }
    
    private func getAllCryptosFromModel() -> [ViewModelCellCryptoProtocol] {
        return self.model.getAllCryptos()
    }
    
    private func getIcons() {
        self.networkService.getAllIcons { [weak self] result in
            switch result {
            case .success(let icons):
                self?.model.setIcons(icons: icons)
            case .failure(let error):
                print ("Error: \(error)")
            }
        }
    }
    
    private func getAllCryptos() {
        self.networkService.getAllCryptoData{ [weak self] result in
            switch result {
            case .success(let models):
                models.forEach { model in
                    let price = model.price_usd ?? 0
                    let formatter = self?.numberFormatter
                    let priceString = formatter?.string(from: NSNumber(value: price))
                    let iconUrl = URL(string: self?.model.getIcons().filter { icon in
                        icon.asset_id == model.asset_id }.first?.url ?? "" )
                    let crypto = ViewModelCellCrypto(name: model.name ?? "",
                                                     symbol: model.asset_id,
                                                     price: priceString ?? "",
                                                     iconUrl: iconUrl)
                    self?.model.addCrypto(crypto: crypto)
                }
                DispatchQueue.main.async {
                    self?.view?.succes()
                    self?.view?.stopIndicator()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.failure(error: error)
                }
                print ("Error: \(error)")
            }
        }
    }
    
}
