//
//  PopUpTransitionDelegate.swift
//  
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

final class PopUpTransitionDelegate<InteractiveTransitionBridge: InteractiveTransitionBridgeProtocol>: NSObject,
    UIViewControllerTransitioningDelegate where InteractiveTransitionBridge.TransitionDirection == TransitionDirection {

    // MARK: - Private Properties

    private let presentationControllerBuilder: PresentationControllerBuilder
    private let interactiveTransitionBridge: InteractiveTransitionBridge
    private let transitionDuration: TimeInterval

    // MARK: - Inititalization

    init(
        presentationControllerBuilder: PresentationControllerBuilder,
        interactiveTransitionBridge: InteractiveTransitionBridge,
        transitionDuration: TimeInterval
    ) {
        self.presentationControllerBuilder = presentationControllerBuilder
        self.interactiveTransitionBridge = interactiveTransitionBridge
        self.transitionDuration = transitionDuration
        super.init()
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        interactiveTransitionBridge.bind(to: presented)
        return presentationControllerBuilder.build(
            forPresented: presented,
            presenting: presenting,
            source: source,
            bridge: interactiveTransitionBridge
        )
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        PresentAnimation(duration: transitionDuration)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimation(duration: transitionDuration)
    }

    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransitionBridge
    }

    func interactionControllerForPresentation(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransitionBridge
    }

}
