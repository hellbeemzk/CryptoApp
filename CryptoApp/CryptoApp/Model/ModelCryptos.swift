//
//  ModelCryptos.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import Foundation

protocol ModelCryptosProtocol {
    func addCrypto(crypto: ViewModelCellCrypto)
    func getAllCryptos() -> [ViewModelCellCrypto]
    func setIcons(icons: [Icon])
    func getIcons() -> [Icon]
}

final class ModelCryptos: ModelCryptosProtocol {
    
    //MARK: - Properties
    private var viewModelsCrypto = [ViewModelCellCrypto]()
    
    private var icons = [Icon]()
    
    //MARK: - Methods
    func addCrypto(crypto: ViewModelCellCrypto) {
        self.viewModelsCrypto.append(crypto)
    }
    
    func getAllCryptos() -> [ViewModelCellCrypto] {
        return self.viewModelsCrypto
    }
    
    func setIcons(icons: [Icon]) {
        self.icons = icons
    }
    
    func getIcons() -> [Icon] {
        return self.icons
    }
    
}
