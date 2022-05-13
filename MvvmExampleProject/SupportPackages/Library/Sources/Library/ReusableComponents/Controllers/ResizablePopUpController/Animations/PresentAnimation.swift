//
//  PresentAnimation.swift
//  Unicredit
//
//  Created by Илья Князьков on 24.01.2021.
//  Copyright © 2021 Surf. All rights reserved.
//

import UIKit

final class PresentAnimation: NSObject {

    // MARK: - Internal properties

    let duration: TimeInterval

    // MARK: - Initializations and deinitializations

    init(duration: TimeInterval) {
        self.duration = duration
    }

    // MARK: - Private methods

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

// MARK: - Extensions

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
