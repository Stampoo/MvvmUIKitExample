//
//  AnotherViewForTesting.swift
//  
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

public final class AnotherViewForTesting: UIView {

    // MARK: - Public Properties

    public var onOpen: () -> Void = { }
    public var onClose: () -> Void = { }

    // MARK: - IBOutlets

    @IBOutlet private weak var openButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!

    // MARK: - UIView

    public override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 20, on: superview)
        openButton.layer.cornerRadius = 12
        closeButton.layer.cornerRadius = 12
    }

    // MARK: - Public Methods

    public static func loadFromNibDirectly() -> Self {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: .module)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            preconditionFailure("\(Self.self) was not loaded from nib")
        }
        return view
    }

    // MARK: - Private Methods

    private func roundCorners(corners: UIRectCorner, radius: CGFloat, on view: UIView?) {
        guard let view = view else {
            return
        }

        let path = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }

    @IBAction private func onDidTapAtOpen() {
        onOpen()
    }

    @IBAction private func onDidTapAtClose() {
        onClose()
    }

}

// MARK: - PopUpContentProtocol

extension AnotherViewForTesting: PopUpContentProtocol {

    public var whiteSpaceBackgroundColor: UIColor {
        backgroundColor ?? .clear
    }

}
