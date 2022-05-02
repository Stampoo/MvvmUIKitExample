//
//  VerticalSpaceCell.swift
//
//
//  Created by Князьков Илья on 30.04.2022.
//

import UIKit
import Core

public final class VerticalSpaceCell: UITableViewCell, ConfigurableItem {

    // MARK: - Nested Types

    public struct Model {
        let height: CGFloat

        public init(height: CGFloat) {
            self.height = height
        }
    }

    // MARK: - Subviews

    @IBOutlet private weak var solidBackgroundView: UIView!
    @IBOutlet private weak var solidBackgroundViewHeightConstraint: NSLayoutConstraint!

    // MARK: - UITableViewCell

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - ConfigurableItem

    public func configure(with model: Model) {
        solidBackgroundViewHeightConstraint.constant = model.height
    }

    public static func bundle() -> Bundle? {
        Bundle.module
    }

}

// MARK: - Private Methods

private extension VerticalSpaceCell {

    func setupInitialState() {
        selectionStyle = .none
        backgroundColor = .clear
        solidBackgroundView.backgroundColor = .clear
    }

}
