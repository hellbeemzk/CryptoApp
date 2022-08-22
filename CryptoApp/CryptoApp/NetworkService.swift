//
//  NetworkService.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getAllCryptoData(completion: @escaping(Result<[Crypto],Error>) -> Void)
    func getAllIcons(completion: @escaping(Result<[Icon],Error>) -> Void)
}

final class NetworkService : NetworkServiceProtocol {
    
    //MARK: - Properties
    private struct Constants {
//        static let apiKey = "?apikey=5466BCC8-853D-4128-A459-83CAAD871FEA"
//        static let apiKey = "?apikey=58ED0869-0BD6-4E74-90AF-3A3CD821E3AC"
//        static let apiKey = "?apikey=CFB67C22-F89B-4E0A-996F-761B4B566900"
//        static let apiKey = "?apikey=58ED0869-0BD6-4E74-90AF-3A3CD821E3AC"
//        static let apiKey = "?apikey=F4659157-1242-41DA-956E-A170A45B8158"
        static let apiKey = "?apikey=D6A661A0-CC30-497E-87C5-F8AA11797D1E"
//        static let apiKey = "?apikey=E8E6C760-2FC8-4571-BA31-61C97C057CBC" // --
//        static let apiKey = "?apikey=F4659157-1242-41DA-956E-A170A45B8158" // --
        static let cryptoDataSourceURL = "https://rest.coinapi.io/v1/assets"
        static let iconsDataSourceURL = "https://rest.coinapi.io/v1/assets/icons/55/"
    }

  // MARK: - Public Methods

    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        guard let url = URL(string: Constants.cryptoDataSourceURL + Constants.apiKey) else {
            print ("No valid cryptoDataSource url")
            return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(
                    cryptos.filter { crypto in
                        guard let price = crypto.price_usd, crypto.id_icon != nil else { return false }
                        return price >= 10 && price <= 15
//                        return price >= 0.1 && price <= 100000
                    }.sorted { $0.volume_1mth_usd ?? 0 > $1.volume_1mth_usd ?? 0 }
                ))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcons(completion: @escaping (Result<[Icon], Error>) -> Void) {
        guard let url = URL(string: Constants.iconsDataSourceURL + Constants.apiKey) else {
            print ("No valid iconsDataSource url")
            return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let icons = try JSONDecoder().decode([Icon].self, from: data)
                completion(.success(icons))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
