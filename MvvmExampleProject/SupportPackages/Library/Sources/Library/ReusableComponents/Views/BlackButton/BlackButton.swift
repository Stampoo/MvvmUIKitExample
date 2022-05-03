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

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
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
        layer.cornerRadius = 12
        clipsToBounds = true
    }

    @objc
    func didTapOnButton() {
        tapEventTransceiver.send(newValue: Void())
    }

}
