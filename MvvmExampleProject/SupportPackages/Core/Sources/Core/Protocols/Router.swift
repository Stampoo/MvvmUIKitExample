//
//  Router.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

import UIKit

public protocol Router {

    func present(_ module: RouterPresentableElement, isAnimated: Bool)
    func dismissTopPresentedModule(isAnimated: Bool)
    func dismissTopPresentedModule(isAnimated: Bool, _ completion: @escaping () -> Void)

    func push(_ module: RouterPresentableElement, isAnimated: Bool)
    func popModule(isAnimated: Bool)

    func setNavigationControllerRootModule(_ module: RouterPresentableElement,
                                                  isAnimated: Bool,
                                                  isNeedHideBar: Bool)
    func setAsRoot(module: RouterPresentableElement)

    init()

}

extension Router {

    var currentDisplayedWindow: UIWindow? {
        if #available(iOS 15, *) {
            let allScenes = UIApplication.shared.connectedScenes
            let windowScene = allScenes.first as? UIWindowScene
            return windowScene?.windows.first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.windows.first(where: \.isKeyWindow)
        }
    }

    var navigationController: UINavigationController? {
        if let tabBar = currentDisplayedWindow?.rootViewController as? UITabBarController {
            return tabBar.selectedViewController as? UINavigationController
        }
        return currentDisplayedWindow?.rootViewController as? UINavigationController
    }

    var tabBarController: UITabBarController? {
        currentDisplayedWindow?.rootViewController as? UITabBarController
    }

}
