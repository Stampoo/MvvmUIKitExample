//
//  TableViewWithCancelTouches.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

import UIKit

public final class TableViewWithCancelEditingRecognizer: UITableView {

    // MARK: - Initialization

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupInitialState()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }

}

// MARK: - Private Methods

private extension TableViewWithCancelEditingRecognizer {

    func setupInitialState() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnTable))
        recognizer.cancelsTouchesInView = false
        addGestureRecognizer(recognizer)
    }

    @objc
    func didTapOnTable() {
        superview?.endEditing(true)
    }

}
