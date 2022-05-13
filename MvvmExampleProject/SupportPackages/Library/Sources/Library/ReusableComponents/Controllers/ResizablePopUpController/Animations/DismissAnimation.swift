//
//  DismissAnimation.swift
//
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

final class DismissAnimation: NSObject {

    // MARK: - Private Properties

    private let duration: TimeInterval

    // MARK: - Initialization

    init(duration: TimeInterval) {
        self.duration = duration
    }

    // MARK: - Private Methods

    private func animator(using context: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let fromView = context.view(forKey: .from),
              let fromViewController = context.viewController(forKey: .from) else {
            fatalError("Presenting view was not found")
        }
        let initialFrame = context.initialFrame(for: fromViewController)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            fromView.frame = initialFrame.offsetBy(dx: .zero, dy: initialFrame.height)
        }
        animator.addCompletion { _ in
            context.completeTransition(!context.transitionWasCancelled)
        }
        return animator
    }

}

// MARK: - UIViewControllerAnimatedTransitioning

extension DismissAnimation: UIViewControllerAnimatedTransitioning {

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
