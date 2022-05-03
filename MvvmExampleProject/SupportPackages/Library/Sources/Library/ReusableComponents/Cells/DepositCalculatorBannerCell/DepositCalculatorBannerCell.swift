//
//  DepositCalculatorBannerCell.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

import UIKit
import Core
import Combine

public final class DepositCalculatorBannerCell: UITableViewCell, ConfigurableItem {

    // MARK: - Nested Types

    public struct Model {
        let percent: Double
        let amount: Double

        public init(percent: Double, amount: Double) {
            self.percent = percent
            self.amount = amount
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var percentLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!

    // MARK: - Private Properties

    private let percentFormatter = NumberFormatter()
    private let amountFormatter = NumberFormatter()

    // MARK: - UITableViewCell

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - ConfigurableItem

    public func configure(with model: Model) {
        percentLabel.text = percentFormatter.string(from: NSNumber(value: model.percent))
        amountLabel.text = amountFormatter.string(from: NSNumber(value: model.amount))
    }

    public static func bundle() -> Bundle? {
        .module
    }

}

// MARK: - Private Methods

private extension DepositCalculatorBannerCell {

    func setupInitialState() {
        selectionStyle = .none

        configureContainerView()
        configurePercentLabel()
        configureTitleLabel()
        configureAmountLabel()
        configureAmountFormatter()
        configurePercentFormatter()
    }

    func configureContainerView() {
        containerView.backgroundColor = .gray.withAlphaComponent(0.12)
        containerView.layer.cornerRadius = 12
    }

    func configurePercentLabel() {
        percentLabel.textColor = .black
        percentLabel.font = .boldSystemFont(ofSize: 29)
    }

    func configureTitleLabel() {
        titleLabel.text = "Сумма в конце срока"
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 14)
    }

    func configureAmountLabel() {
        amountLabel.textColor = .black
        amountLabel.font = .systemFont(ofSize: 17)
    }

    func configureAmountFormatter() {
        amountFormatter.locale = .current
        amountFormatter.currencyGroupingSeparator = " "
        amountFormatter.minimumFractionDigits = .zero
        amountFormatter.numberStyle = .currency
        amountFormatter.currencyCode = "RUB"
    }

    func configurePercentFormatter() {
        percentFormatter.locale = .current
        percentFormatter.minimumFractionDigits = .zero
        percentFormatter.numberStyle = .percent
    }

}
