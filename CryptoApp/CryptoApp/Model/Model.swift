//
//  Model.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let volume_1mth_usd: Float?
    let price_usd: Float?
    let id_icon: String?
}

struct Icon: Codable {
    let asset_id: String
    let url: String
}
