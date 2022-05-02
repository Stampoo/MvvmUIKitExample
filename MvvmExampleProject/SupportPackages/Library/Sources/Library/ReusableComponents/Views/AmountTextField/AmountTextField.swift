//
//  AmountTextField.swift
//  
//
//  Created by Князьков Илья on 01.05.2022.
//

import UIKit

final class AmountTextField: UITextField {

    // MARK: - Private Properties

    private var model: AmountTextFieldModel?
    private let currencyFormatter = NumberFormatter()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }

    // MARK: - UITextField

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let insets = model?.insets else {
            return bounds
        }
        return bounds.inset(by: insets)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let insets = model?.insets else {
            return bounds
        }
        return bounds.inset(by: insets)
    }

    // MARK: - Internal Methods

    func configure(from model: AmountTextFieldModel) {
        self.model = model

        currencyFormatter.currencyCode = model.currency.rawValue
        font = model.font
        textColor = model.textColor
    }

}

// MARK: - UITextFieldDelegate

extension AmountTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard string.isEmpty, let text = textField.text else {
            return true
        }
        if text.filter(\.isWholeNumber).dropLast().isEmpty {
            textField.text = ""
            model?.amountDidChangeEvent.send(newValue: .zero)
        }
        if let amount = Double(text.filter(\.isWholeNumber).dropLast()) {
            textField.text = currencyFormatter.string(from: NSNumber(value: amount))
        }
        return true
    }

}

// MARK: - Private methods

private extension AmountTextField {

    @objc
    func valueDidChangedInAmountField(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if let amount = Double(text.filter(\.isWholeNumber)) {
            textField.text = currencyFormatter.string(from: NSNumber(value: amount))
            model?.amountDidChangeEvent.send(newValue: amount)
        }
    }

    func setupInitialState() {
        delegate = self
        addTarget(
            self,
            action: #selector(valueDidChangedInAmountField(_:)),
            for: .editingChanged
        )

        configureFormatter()
    }

    func configureFormatter() {
        currencyFormatter.locale = .current
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.currencyGroupingSeparator = " "
        currencyFormatter.minimumFractionDigits = .zero
        currencyFormatter.numberStyle = .currency
    }

}
