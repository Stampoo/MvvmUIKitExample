//
//  DismissAnimation.swift
//  Unicredit
//
//  Created by Илья Князьков on 24.01.2021.
//  Copyright © 2021 Surf. All rights reserved.
//

import UIKit

final class DismissAnimation: NSObject {

    // MARK: - Internal properties

    let duration: TimeInterval

    // MARK: - Initializations and deinitializations

    init(duration: TimeInterval = 0.3) {
        self.duration = duration
    }

    // MARK: - Private methods

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

// MARK: - Extensions

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
