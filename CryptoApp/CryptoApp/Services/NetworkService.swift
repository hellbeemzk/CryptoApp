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
    
    //MARK: - Constants
    private struct Constants {
        static let apiKey = "?apikey=CFB67C22-F89B-4E0A-996F-761B4B566900"
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
                        return price >= 0.1 && price <= 100000
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
