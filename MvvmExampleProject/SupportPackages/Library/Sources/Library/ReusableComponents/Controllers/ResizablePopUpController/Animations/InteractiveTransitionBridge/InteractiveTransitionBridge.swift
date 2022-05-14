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
    private var latestGesturePanLocation: CGPoint = .zero
    private var tresholdNecessaryForClosing: CGFloat {
        (presentedController?.view.frame.height ?? .zero) / 2
    }

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

        let panRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(onPresentedViewDidPanned(recognizer:))
        )
        presentedController?.view.addGestureRecognizer(panRecognizer)

        self.panRecognizer = panRecognizer
    }

}

// MARK: - Private Methods

private extension InteractiveTransitionBridge {

    @objc
    func onPresentedViewDidPanned(recognizer: UIPanGestureRecognizer) {
        guard case .dismiss = direction else {
            return
        }
        handleAndDismissIfNeeded(recognizer: recognizer)
    }

    func handleAndDismissIfNeeded(recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: presentedController?.view)
        switch recognizer.state {
        case .began:
            applyChangesAfterGestureDidBegan(currentTouchLocation: touchLocation)
        case .changed:
            applyChangesAfterGestureDidChanged(recognizer: recognizer)
        case .ended, .cancelled:
            applyChangesAfterGestureDidEnded(currentYTouchLocation: touchLocation.y)
        case .failed:
            cancel()
        default:
            break
        }
    }

    func applyChangesAfterGestureDidBegan(currentTouchLocation: CGPoint) {
        latestGesturePanLocation = currentTouchLocation
        pause()
        if percentComplete == 0 {
            presentedController?.dismiss(animated: true)
        }
    }

    func applyChangesAfterGestureDidChanged(recognizer: UIPanGestureRecognizer) {
        update(percentComplete + getIncreasedYTranslation(for: recognizer))
        recognizer.setTranslation(.zero, in: nil)
    }

    func applyChangesAfterGestureDidEnded(currentYTouchLocation: CGFloat) {
        let offsetY = latestGesturePanLocation.y - currentYTouchLocation
        offsetY > tresholdNecessaryForClosing ? cancel() : finish()
    }

}

// MARK: - Calculate translation measurement

private extension InteractiveTransitionBridge {

    func getIncreasedYTranslation(for recognizer: UIPanGestureRecognizer) -> CGFloat {
        let currentTranslationOnY = recognizer.translation(in: presentedController?.view).y
        return currentTranslationOnY / (presentedController?.view.frame.height ?? 0)
    }

}
