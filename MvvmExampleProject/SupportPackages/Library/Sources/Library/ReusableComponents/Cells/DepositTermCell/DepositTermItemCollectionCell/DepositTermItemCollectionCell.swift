//
//  DepositTermItemCollectionCell.swift
//  
//
//  Created by Князьков Илья on 02.05.2022.
//

import UIKit
import Core
import Combine

final class DepositTermItemCollectionCell: UICollectionViewCell, ConfigurableItem {

    // MARK: - Nested Types

    struct Model {
        let title: String
        fileprivate let selectEventTransceiver = BaseEventTransceiver<Void, Never>()

        var selectEventPublisher: AnyPublisher<Void, Never> {
            selectEventTransceiver.publisher.eraseToAnyPublisher()
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Private Properties

    private var model: Model?
    private var currentIsSelectedState: Bool = false

    // MARK: - UITableViewCell

    override var isSelected: Bool {
        didSet {
            handleSelectDeselectEvents()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

    // MARK: - ConfigurableItem

    func configure(with model: Model) {
        self.model = model
        titleLabel.text = model.title
    }

    static func bundle() -> Bundle? {
        Bundle.module
    }

}

// MARK: - Private Methods

private extension DepositTermItemCollectionCell {

    func setupInitialState() {
        configureTitleLabel()
    }

    func configureTitleLabel() {
        backgroundColor = .gray.withAlphaComponent(0.12)
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 17)
    }

    func handleSelectDeselectEvents() {
        defer {
            currentIsSelectedState = isSelected
        }
        sendEventsAboutCurrentIsSelectState()
        changeAppearanceOnCurrentSelectState()
    }

    func sendEventsAboutCurrentIsSelectState() {
        guard currentIsSelectedState != isSelected, isSelected else {
            return
        }
        model?.selectEventTransceiver.send(newValue: Void())
    }

    func changeAppearanceOnCurrentSelectState() {
        backgroundColor = isSelected ? .black : .gray.withAlphaComponent(0.12)
        titleLabel.textColor = isSelected ? .white : .black
    }

}
