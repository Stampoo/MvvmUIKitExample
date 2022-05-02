//
//  DepositSumCell.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

import UIKit
import Core
import Combine

public final class DepositSumCell: UITableViewCell, ConfigurableItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: AmountTextField!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Private Properties

    private var model: Model?
    private var cancellableEventsContainer: Set<AnyCancellable> = []

    // MARK: - UITableViewCell

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - ConfigurableItem

    public func configure(with model: DepositSumCellModel) {
        self.model = model

        let fieldInsets = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
        let amountTextFieldModel = AmountTextFieldModel(
            currency: .rub,
            insets: fieldInsets,
            font: .boldSystemFont(ofSize: 17),
            textColor: .black
        )
        textField.configure(from: amountTextFieldModel)
        titleLabel.text = model.title
        descriptionLabel.text = model.state.text
        descriptionLabel.textColor = model.state.textColor

        amountTextFieldModel.amountDidChangePublisher
            .sink(receiveValue: model.sumDidChangeEvent.send(newValue:))
            .store(in: &cancellableEventsContainer)
    }

    public static func bundle() -> Bundle? {
        Bundle.module
    }

}

// MARK: - Private Methods

private extension DepositSumCell {

    func setupInitialState() {
        selectionStyle = .none

        configureTitleLabel()
        configureTextField()
        configureDescriptionLabel()
    }

    func configureTitleLabel() {
        titleLabel.text = nil
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 14)
    }

    func configureDescriptionLabel() {
        descriptionLabel.text = nil
        descriptionLabel.font = .systemFont(ofSize: 14)
    }

    func configureTextField() {
        textField.backgroundColor = .gray.withAlphaComponent(0.12)
        textField.layer.cornerRadius = 12
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
    }

}
