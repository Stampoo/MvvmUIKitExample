//
//  BlackButton.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

import UIKit
import EventTransceiver
import Combine

public final class BlackButton: UIButton {

    // MARK: - Public Properties

    public var tapEventPublisher: AnyPublisher<Void, Never> {
        tapEventTransceiver.publisher.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let tapEventTransceiver = BaseEventTransceiver<Void, Never>()
    private var pressAnimator = UIViewPropertyAnimator()
    private var animationDuration: TimeInterval = 0.2
    private var hasPressAnimationState: Bool = true

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }

    // MARK: - UIResponder

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        startPressAnimation()
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        startUnpressAnimation()
    }

    // MARK: - UIButton

    override public func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 17)
    }

}

// MARK: - Private Methods

private extension BlackButton {

    func setupInitialState() {
        addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        setBackgroundImage(.solidColor(.black), for: .normal)
        setBackgroundImage(.solidColor(.darkGray), for: .disabled)
        layer.cornerRadius = 12
        clipsToBounds = true
    }

    @objc
    func didTapOnButton() {
        tapEventTransceiver.send(newValue: Void())
    }

    func startPressAnimation() {
        guard hasPressAnimationState else {
            return
        }
        self.pressAnimator.stopAnimation(false)
        self.pressAnimator = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 5) {
            self.transform = .init(scaleX: 0.9, y: 0.9)
        }
        pressAnimator.startAnimation()
    }

    func startUnpressAnimation() {
        guard hasPressAnimationState else {
            return
        }
        self.pressAnimator.stopAnimation(false)
        self.pressAnimator = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 5) {
            self.transform = .identity
        }
        self.pressAnimator.startAnimation()
    }

}
