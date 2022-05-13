//
//  CloseIndicatorView.swift
//  
//
//  Created by Князьков Илья on 13.05.2022.
//


import UIKit
import Core
import Combine

public final class CloseIndicatorView: UIView {

    // MARK: - Internal Properties

    var panEventPublisher: AnyPublisher<CGPoint, Never> {
        panEventTransceiver.publisher.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let panEventTransceiver = BaseEventTransceiver<CGPoint, Never>()

    // MARK: - UITableViewCell

    override public func awakeFromNib() {
        super.awakeFromNib()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onDidPan(panRecognizer:)))
        addGestureRecognizer(recognizer)
    }

    func configure(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }

    public static func loadFromNibDirectly(bundle: Bundle) -> Self {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            preconditionFailure("\(Self.self) was not loaded from nib")
        }
        return view
    }

}

// MARK: - Private Methods

private extension CloseIndicatorView {

    @objc
    func onDidPan(panRecognizer: UIPanGestureRecognizer) {
        panEventTransceiver.send(newValue: panRecognizer.location(in: self))
    }

}
