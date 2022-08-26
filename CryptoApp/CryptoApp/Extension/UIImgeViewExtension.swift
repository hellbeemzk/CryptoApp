//
//  UIImgeViewExtension.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
        
    func loadImageUsingCache(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("invalid url for donwload image")
            return
        }
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        } else {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self.image = image
                    }
                }
            }
            task.resume()
        }
    }
}
