//
//  DepositConditionsCell.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

import UIKit
import Core
import Combine

public final class DepositConditionsCell: UITableViewCell, ConfigurableItem {

    // MARK: - Nested Types

    public struct Model {
        let conditions: [ConditionModel]

        public init(conditions: [ConditionModel]) {
            self.conditions = conditions
        }
    }

    public struct ConditionModel {
        let title: String
        let description: String
        let selectEventTransceiver = BaseEventTransceiver<Void, Never>()

        public var selectEventPublisher: AnyPublisher<Void, Never> {
            selectEventTransceiver.publisher.eraseToAnyPublisher()
        }

        public init(title: String, description: String) {
            self.title = title
            self.description = description
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var stackView: UIStackView!

    // MARK: - Private Properties

    private var model: Model?
    private var cancellableEventsContainer: Set<AnyCancellable> = []
    private var currentConditions: Set<DepositConditionView> = []

    // MARK: - UITableViewCell

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - ConfigurableItem

    public func configure(with model: Model) {
        self.model = model
        fillConditions(from: model.conditions)
    }

    public static func bundle() -> Bundle? {
        .module
    }

}

// MARK: - Private Methods

private extension DepositConditionsCell {

    func fillConditions(from conditionModels: [ConditionModel]) {
        guard currentConditions.isEmpty else {
            return
        }
        for conditionModel in conditionModels {
            let conditionView: DepositConditionView = .loadFromNibDirectly()
            let model = DepositConditionView.Model(title: conditionModel.title, description: conditionModel.description)
            conditionView.configure(with: model)
            currentConditions.insert(conditionView)
            stackView.addArrangedSubview(conditionView)

            model.selectEventPublisher
                .sink { [weak self] _ in
                    conditionView.setIsSelectedState(true)
                    conditionModel.selectEventTransceiver.send(newValue: Void())
                    return self?.currentConditions
                        .filter { $0 != conditionView }
                        .forEach { $0.setIsSelectedState(false) }
                }
                .store(in: &cancellableEventsContainer)
        }
    }

    func setupInitialState() {
        selectionStyle = .none

        stackView.spacing = 25
    }

}
