//
//  BaseRouter.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

import UIKit

public final class BaseRouter: Router {

    // MARK: - Private Properties

    private var topNavigationController: UINavigationController? {
        topViewController()?.navigationController
    }

    // MARK: - Router

    public required init() { }

    public func present(_ module: RouterPresentableElement, isAnimated: Bool) {
        topViewController()?.present(module.presentableController, animated: isAnimated)
    }

    public func push(_ module: RouterPresentableElement, isAnimated: Bool) {
        topNavigationController?.pushViewController(module.presentableController, animated: isAnimated)
    }

    public func popModule(isAnimated: Bool) {
        topNavigationController?.popViewController(animated: isAnimated)
    }

    public func dismissTopPresentedModule(isAnimated: Bool) {
        topViewController()?.dismiss(animated: isAnimated, completion: nil)
    }

    public func dismissTopPresentedModule(isAnimated: Bool, _ completion: @escaping () -> Void) {
        topViewController()?.dismiss(animated: isAnimated, completion: completion)
    }

    public func setNavigationControllerRootModule(_ module: RouterPresentableElement,
                                                  isAnimated: Bool,
                                                  isNeedHideBar: Bool) {
        navigationController?.isNavigationBarHidden = isNeedHideBar
        navigationController?.setViewControllers([module.presentableController], animated: isAnimated)
    }

    public func setAsRoot(module: RouterPresentableElement) {
        currentDisplayedWindow?.rootViewController = module.presentableController
    }

}

// MARK: - Private Methods

private extension BaseRouter {

    func topViewController(_ controller: UIViewController? = BaseRouter().currentDisplayedWindow?.rootViewController) -> UIViewController? {

        if let navigationController = controller as? UINavigationController {
            if let visibleController = navigationController.visibleViewController {
                return topViewController(visibleController)
            }
        }

        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(selected)
            }
        }

        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }

        return controller
    }

}
