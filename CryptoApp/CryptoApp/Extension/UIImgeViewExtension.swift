//
//  UIImgeViewExtension.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self?.image = UIImage(data:data)
                }
            }
        }
        task.resume()
    }
}
