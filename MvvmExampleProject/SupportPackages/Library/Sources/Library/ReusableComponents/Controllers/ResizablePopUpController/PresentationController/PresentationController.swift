//
//  PresentationController.swift
//
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit
import Combine
import EventTransceiver

final class PresentationController<InteractiveTransitionBridge: InteractiveTransitionBridgeProtocol>: UIPresentationController where InteractiveTransitionBridge.TransitionDirection == TransitionDirection {

    // MARK: - Public Properties

    public var tapEventPublisher: AnyPublisher<Void, Never> {
        tapOnBlurredViewEventTransceiver.publisher.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let sizeOfContent: CGSize
    private let parentFrame: CGRect
    private lazy var blurredView = getBlurredView()
    private let tapOnBlurredViewEventTransceiver = BaseEventTransceiver<Void, Never>()
    private let transitionDismissalBridge: InteractiveTransitionBridge

    // MARK: - PresentationController

    override var frameOfPresentedViewInContainerView: CGRect {
        getFrameForContainer()
    }

    // MARK: - Initialization

    init(
        presentedViewController: UIViewController,
        presenting: UIViewController,
        sizeOfContent: CGSize,
        relevantTo parentFrame: CGRect,
        transitionDismissalBridge: InteractiveTransitionBridge
    ) {
        self.sizeOfContent = sizeOfContent
        self.parentFrame = parentFrame
        self.transitionDismissalBridge = transitionDismissalBridge
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }


    // MARK: - Public methods

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let presentedView = presentedView else {
            fatalError("Presented view was not found")
        }
        [blurredView, presentedView].forEach { containerView?.addSubview($0) }
        alongsideTransition(animate: self.blurredView.alpha = 1)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurredView.frame = parentFrame
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        alongsideTransition(animate: self.blurredView.alpha = .zero)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            blurredView.removeFromSuperview()
        } else {
            transitionDismissalBridge.updateDirection(.dismiss)
        }
    }

    // MARK: - Internal methods

    func alongsideTransition(animate: @autoclosure @escaping () -> Void) {
        presentedViewController.transitionCoordinator?.animate { _ in
            animate()
        }
    }

    // MARK: - Private methods

    private func getFrameForContainer() -> CGRect {
        let topOffsetOnY = parentFrame.height - sizeOfContent.height
        let origin = CGPoint(x: .zero, y: topOffsetOnY)
        return CGRect(origin: origin, size: sizeOfContent)
    }

    private func getBlurredView() -> UIView {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = VisualEffectViewWithIntensity(
            effect: blurEffect,
            intensity: .low
        )
        visualEffectView.alpha = .zero

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(onDidTapAtBlurView)
        )
        visualEffectView.addGestureRecognizer(tapGesture)

        return visualEffectView
    }

    @objc
    private func onDidTapAtBlurView() {
        tapOnBlurredViewEventTransceiver.send(newValue: Void())
    }

}
