//
//  SceneDelegate.swift
//  CryptoApp
//
//  Created by Konstantin on 22.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = Assembly.shared.tabBarController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        self.window = window
    }
}

