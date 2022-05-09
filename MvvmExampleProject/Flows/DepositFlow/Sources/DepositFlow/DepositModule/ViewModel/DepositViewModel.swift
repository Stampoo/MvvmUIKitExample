//
//  Copyright © Surf. All rights reserved.
//

import EventTransceiver

final class DepositViewModel: DepositViewOutput, DepositModuleInput, DepositModuleOutput {

    // MARK: - DepositViewOutput

    var infoPreinitPublisher: AnyPublisher<DepositInformationPreinitModel, Never> {
        infoPreinitEventTransceiver.publisher.eraseToAnyPublisher()
    }
    var depositInfoPublisher: AnyPublisher<DepositInformationModel, Never> {
        depositInfoEventTransceiver.publisher.eraseToAnyPublisher()
    }
    var depositConditionsPublisher: AnyPublisher<[DepositCondition], Never> {
        depositConditionsTransceiver .publisher.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let infoPreinitEventTransceiver = BaseEventTransceiver<DepositInformationPreinitModel, Never>()
    private let depositInfoEventTransceiver = BaseEventTransceiver<DepositInformationModel, Never>()
    private let depositConditionsTransceiver  = BaseEventTransceiver<[DepositCondition], Never>()
    private let model: DepositModelProtocol
    private let availableDepositTerms: [DepositTerm] = [
        .threeMounth,
        .sixMounth,
        .nineMounth,
        .oneYear,
        .oneAndHalfYear
    ]
    private let availableDepositConditions: [DepositCondition] = [
        .withReplenishCondition,
        .withWithdrawCondition,
        .withPercentCondition
    ]

    // MARK: - Initialization

    init(model: DepositModelProtocol) {
        self.model = model
    }

    // MARK: - DepositViewOutput

    func didEventTriggered(_ triggeredEvent: DepositEvents) {
        switch triggeredEvent {
        case .viewDidLoad:
            let preinitModel = DepositInformationPreinitModel(
                terms: availableDepositTerms,
                conditions: availableDepositConditions
            )
            infoPreinitEventTransceiver.send(newValue: preinitModel)
        case .sumDidChanged(let _):
            updateDepositInformation()
        case .termDidChanged(let termInMoths):
            updateConditions(dependOn: termInMoths)
            updateDepositInformation()
        case .conditionDidChanged(let newCondition):
            updateConditions(dependOn: newCondition)
        }
    }

}

// MARK: - Private Methods

private extension DepositViewModel {

    func updateConditions(dependOn months: Int) {
        let disabledConditions = model.getDisabledConditionsBasedOn(months: months)
        let newConditions: [DepositCondition] = availableDepositConditions.map { condition in
            guard disabledConditions.contains(condition) else {
                return condition
            }
            var condition = condition
            condition.isDisabled = true
            return condition
        }
        depositConditionsTransceiver.send(newValue: newConditions)
    }

    func updateConditions(dependOn selectedCondition: DepositCondition) {
        let selectedConditions = model.getSelectedConditionsBasedOn(condition: selectedCondition)
        let newConditions: [DepositCondition] = availableDepositConditions.map { condition in
            guard selectedConditions.contains(condition) else {
                return condition
            }
            var condition = condition
            condition.isSelected = true
            return condition
        }
        depositConditionsTransceiver.send(newValue: newConditions)
    }

    func updateDepositInformation() {
        let bannerInfoModel = DepositInformationModel(
            percent: model.getDepositPercentBasedOnCurrentConditions(),
            amount: model.getTotalAmountBasedOnCurrentConditions()
        )
        depositInfoEventTransceiver.send(newValue: bannerInfoModel)
    }

}
