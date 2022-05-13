//
//  PresentationControllerBuilder.swift
//  
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

struct PresentationControllerBuilder {

    // MARK: - Prviate Properties

    private let sizeOfContent: CGSize
    private let parentFrame: CGRect

    // MARK: - Initialization

    init(sizeOfContent: CGSize, parentFrame: CGRect) {
        self.sizeOfContent = sizeOfContent
        self.parentFrame = parentFrame
    }

    // MARK: - Internal Methods

    func build<InteractiveTransitionBridge: InteractiveTransitionBridgeProtocol>(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController,
        bridge interactiveTransitionBridge: InteractiveTransitionBridge
    ) -> UIPresentationController where InteractiveTransitionBridge.TransitionDirection == TransitionDirection {
        PresentationController<InteractiveTransitionBridge>(
            presentedViewController: presented,
            presenting: presenting ?? source,
            sizeOfContent: sizeOfContent,
            relevantTo: parentFrame,
            transitionDismissalBridge: interactiveTransitionBridge
        )
    }

}
