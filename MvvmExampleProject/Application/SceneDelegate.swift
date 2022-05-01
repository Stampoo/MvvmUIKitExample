//
//  SceneDelegate.swift
//  MvvmExampleProject
//
//  Created by Князьков Илья on 30.04.2022.
//

import UIKit
import DepositFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let depositCoordinator = DepositCoordinator()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()

        startRootCoordinator()
    }

}

// MARK: - Private Methods

private extension SceneDelegate {

    func startRootCoordinator() {
        depositCoordinator.start()
    }

}

