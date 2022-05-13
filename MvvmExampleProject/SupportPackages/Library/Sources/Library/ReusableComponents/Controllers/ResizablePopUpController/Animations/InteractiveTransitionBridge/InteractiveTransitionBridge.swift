//
//  InteractiveTransitionBridge.swift
//  
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

final class InteractiveTransitionBridge: UIPercentDrivenInteractiveTransition, InteractiveTransitionBridgeProtocol {

    // MARK: - Private Properties

    private weak var presentedController: UIViewController?
    private var panRecognizer: UIPanGestureRecognizer?

    // MARK: - UIPercentDrivenInteractiveTransition

    override var wantsInteractiveStart: Bool {
        get {
            direction == .present ? false : panRecognizer?.state == .began
        }
        set { }
    }

    // MARK: - InteractiveTransitionBridgeProtocol

    var direction: TransitionDirection = .present

    func updateDirection(_ newDirection: TransitionDirection) {
        self.direction = newDirection
    }

    func bind(to controller: UIViewController) {
        presentedController = controller

        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        presentedController?.view.addGestureRecognizer(panRecognizer!)
    }

}

// MARK: - Gesture Handling

extension InteractiveTransitionBridge {

    @objc
    func handle(recognizer: UIPanGestureRecognizer) {
        direction == .present
            ? handlePresentation(recognizer: recognizer)
            : handleDismiss(recognizer: recognizer)
    }

    func handlePresentation(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            pause()
        case .changed:
            let increment = -recognizer.incrementToBottom(maxTranslation: maxTranslation)
            update(percentComplete + increment)
        case .ended, .cancelled:
            recognizer.isProjectedToDownHalf(maxTranslation: maxTranslation) ? cancel() : finish()
        case .failed:
            cancel()
        default:
            break
        }
    }

    func handleDismiss(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            pause() // Pause allows to detect isRunning
            if !isRunning {
                presentedController?.dismiss(animated: true) // Start the new one
            }
        case .changed:
            update(percentComplete + recognizer.incrementToBottom(maxTranslation: maxTranslation))
        case .ended, .cancelled:
            recognizer.isProjectedToDownHalf(maxTranslation: maxTranslation) ? finish() : cancel()
        case .failed:
            cancel()
        default:
            break
        }
    }

    var maxTranslation: CGFloat {
        return presentedController?.view.frame.height ?? 0
    }

    /// `pause()` before call `isRunning`
    private var isRunning: Bool {
        return percentComplete != 0
    }
}

// MARK: - Extensions

extension CGFloat { // Velocity value
    func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGFloat {
        // Magic formula from WWDC
        let multiplier = 1 / (1 - decelerationRate.rawValue) / 1000
        return self * multiplier
    }
}

extension CGPoint {
    func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
        return CGPoint(x: x.projectedOffset(decelerationRate: decelerationRate),
                       y: y.projectedOffset(decelerationRate: decelerationRate))
    }
}

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x,
                       y: left.y + right.y)
    }
}

extension UIPanGestureRecognizer {
    func projectedLocation(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
        let velocityOffset = velocity(in: view).projectedOffset(decelerationRate: .normal)
        let projectedLocation = location(in: view!) + velocityOffset
        return projectedLocation
    }
}

extension UIPanGestureRecognizer {
    func isProjectedToDownHalf(maxTranslation: CGFloat) -> Bool {
        let endLocation = projectedLocation(decelerationRate: .fast)
        let isPresentationCompleted = endLocation.y > maxTranslation / 2

        return isPresentationCompleted
    }

    func incrementToBottom(maxTranslation: CGFloat) -> CGFloat {
        let translation = self.translation(in: view).y
        setTranslation(.zero, in: nil)

        let percentIncrement = translation / maxTranslation
        return percentIncrement
    }
}
