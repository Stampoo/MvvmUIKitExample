//
//  PresentAnimation.swift
//
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

final class PresentAnimation: NSObject {

    // MARK: - Private Properties

    private let duration: TimeInterval

    // MARK: - Initialization

    init(duration: TimeInterval) {
        self.duration = duration
    }

    // MARK: - Private Methods

    private func animator(using context: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let toView = context.view(forKey: .to),
              let toViewController = context.viewController(forKey: .to) else {
            fatalError("Presenting view was not found")
        }
        let finalFrame = context.finalFrame(for: toViewController)
        toView.frame = finalFrame.offsetBy(dx: .zero, dy: finalFrame.height)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            toView.frame = finalFrame
        }
        animator.addCompletion { position in
            context.completeTransition(!context.transitionWasCancelled)
        }
        return animator
    }

}

// MARK: - UIViewControllerAnimatedTransitioning

extension PresentAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using context: UIViewControllerContextTransitioning) {
        animator(using: context).startAnimation()
    }

    func interruptibleAnimator(using context: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        animator(using: context)
    }

}
